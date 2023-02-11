# README

## Setting up

Make sure ruby and nodejs are installed

```bash
asdf plugin-add ruby
asdf plugin-add nodejs
asdf install
```

Install rails global executable and create project

```bash
gem install rails
mkdir the_archive
cd the_archive
rails new .
```

Add cucumber as dependency

```bash
bundle add cucumber-rails
bundle add database_cleaner
rails generate cucumber:install
```

In your `Gemfile`, move the added dependencies to the `test` group.

Run cucumber tests (no test has been written yet)

```bash
bundle exec cucumber
```

The output should be similar to

```plain
0 scenarios
0 steps
0m0.000s
```

Add the github workflow file (`.github/workflows/main.yml`) which will run
cucumber tests on every push to the repository. You have to add the platform-specific
gems to the lockfile if your local dev environment is not the same as the actions
runner:

```bash
bundle lock --add-platform x86_64-linux
```

## Link to a git repository

```bash
git add .
git commit -m "Initial commit"
git remote add origin git@github.com:rewritten/the_archive.git
git push -u origin main
```

## Writing scenarios

Add scenarios to `features/adding_documents.feature`:

```gherkin
Feature: Adding documents to the archive

    Users can add documents, optionally with an attachment, to the archive.

    Background: There is a user in the system

        Given there is a user named "Riley Smith"

    Scenario: Adding a document to the archive

        Given I am logged in as "Riley Smith"
        When I go to the "add document" page
        And I fill the form with
            | Title       | My first document         |
            | Description | This is my first document |
            | Tags        | first, document           |
            | Location    | Basement                  |
            | Date        | 2012-01-01                |
            | Identifier  | 1234                      |
        And I press "Add"
        Then the document is added to the archive
        And the document's identifier is "basement-1234"
```

Then run `bundle exec cucumber` again. The output should be similar to

```plain
$ bundle exec cucumber
Using the default profile...
Feature: Adding documents to the archive
    Users can add documents, optionally with an attachment, to the archive.

  Background: There is a user in the system   # features/adding_documents.feature:5
    Given there is a user named "Riley Smith" # features/adding_documents.feature:7

  Scenario: Adding a document to the archive         # features/adding_documents.feature:9
    Given I am logged in as "Riley Smith"            # features/adding_documents.feature:11

...

3 scenarios (3 undefined)
23 steps (23 undefined)
0m0.007s

You can implement step definitions for undefined steps with these snippets:

Given('there is a user named {string}') do |string|
  pending # Write code here that turns the phrase above into concrete actions
end
```

Take all the output and put it into `features/step_definitions/adding_documents.rb`:

```ruby
Given('there is a user named {string}') do |string|
  pending # Write code here that turns the phrase above into concrete actions
end
```

Run `bundle exec cucumber` again. The output is now

```plain
$ bundle exec cucumber
Using the default profile...
Feature: Adding documents to the archive
    Users can add documents, optionally with an attachment, to the archive.

  Background: There is a user in the system   # features/adding_documents.feature:5
    Given there is a user named "Riley Smith" # features/step_definitions/adding_documents.rb:1

  Scenario: Adding a document to the archive       # features/adding_documents.feature:9
    Given I am logged in as "Riley Smith"          # features/step_definitions/adding_documents.rb:5
    When I go to the "add document" page           # features/step_definitions/adding_documents.rb:9

...

3 scenarios (3 pending)
23 steps (20 skipped, 3 pending)
0m0.006s
```

where you can see the steps are still pending, but the definitions are found.

Add more features and scenarios as needed.

## Filling in step definitions

All steps are equal in cucumber, no matter if they are a `Given`, `When` or `Then`,
`And` or `But`. We will write expectations in the `Then` steps, so they will fail
with a reasonable message, but any failure will be reported as a failed test.

So we start with the very first step, which is `Given there is a user named "Riley Smith"`.

Cucumber had already generated a stub for the step definition, and it was smart enough
to use the string argument as the variable name:

```ruby
Given('there is a user named {string}') do |string|
  pending # Write code here that turns the phrase above into concrete actions
end
```

Now we can write the actual step definition in plain ruby code. We want a user to
exist, and we plan to use ActiveRecord to manage the persistence, so we can imagine
that we have a `User` model, and modify the step definition to

```ruby
Given('there is a user named {string}') do |string|
  User.find_or_create_by!(name: string)
end
```

If we run the tests again, we get a new error

```plain
  Background: There is a user in the system   # features/adding_documents.feature:5
    Given there is a user named "Riley Smith" # features/step_definitions/adding_documents.rb:1
      uninitialized constant User (NameError)  <<---- the error is here, usually in red
      ./features/step_definitions/adding_documents.rb:2:in `"there is a user named {string}"'
      features/adding_documents.feature:7:in `there is a user named "Riley Smith"'

...

7 scenarios (3 failed, 4 pending)
38 steps (3 failed, 31 skipped, 4 pending)
0m0.017s
```

That means that we have written a failing test! We can now make this step pass by
actually implementing the User model, and in this case it is as easy as

```bash
rails generate model User name:string
```

This will generate a migration and a model file in `app/models/user.rb`. We can
now run the migration and the tests again, and the first step will be finally
green!

```bash
bin/rails db:migrate RAILS_ENV=test
```

```plain
$ bundle exec cucumber
Using the default profile...
Feature: Adding documents to the archive
  Users can add documents, optionally with an attachment, to the archive.

  Background: There is a user in the system   # features/adding_documents.feature:5
    Given there is a user named "Riley Smith" <<-- this is now green!

  Scenario: Adding a document to the archive       # features/adding_documents.feature:9
    Given I am logged in as "Riley Smith" <<-- this is yellow now (pending)
    When I go to the "add document" page <<-- this is blue (unreachable)
```

One second... what is all this red, yellow, green and blue? People might have their
own conventions, and set up their terminal to display the output in different ways.

Let's reconfigure the output so we can rely on text instead of colors. Add this
line to `cucumber.yml`:

```yaml
text: --publish-quiet --no-color --no-multiline --no-source --strict --fail-fast
```

With this, we will have a more compact output, without all the colors, file names
and data. We will also (because of the --strict flag) get an error if we have
a pending step, so if we run the tests again with this new profile, we will get

```plain
$ bundle exec cucumber -ptext
Using the text profile...
Feature: Adding documents to the archive
  Users can add documents, optionally with an attachment, to the archive.

  Background: There is a user in the system
    Given there is a user named "Riley Smith"

  Scenario: Adding a document to the archive
    Given I am logged in as "Riley Smith"
      TODO (Cucumber::Pending)
      ./features/step_definitions/adding_documents.rb:6:in `"I am logged in as {string}"'
      features/adding_documents.feature:11:in `I am logged in as "Riley Smith"'
```

Now we can see that the step is pending, and we can implement it.

Let's implement the remaining steps for this scenario with the same cycle:

- write the step definition so it interacts with the system in the expected way
  (which could be opening a page, or clicking a button, or filling in a form)
- run the tests (the step might now fail)
- implement the missing code
- run the tests again (the step should now pass)
- rinse and repeat

We can use a lot of shortcuts to speed up the process. For example we can use
rails model and scaffold generators to create the models and controllers we need:

```bash
rails g scaffold Document title:string description:text location:references date:date identifier:string
rails g model Location name:string
rails g model Tag name:string
rails g migration CreateDocumentsTags document:references tag:references
```

We will also use ActiveStorage to manage attachments, so we need to prepare our
database for it:

```bash
bin/rails active_storage:install
```

And finally we can run the migrations:

```bash
bin/rails db:migrate RAILS_ENV=test
```

We will also have to update routes and controllers, so all the system will start
to work.

[Some hours pass...]

Finally, we can successfully run the "Adding documents to the archive" feature.
We have added a number of new code files, to help decouple the document form to
the model:

- A `Current` class that will hold request information. We have to take care of
  not abusing thread-locals, but this class will be useful when we need to
  develop the authenitcation system. The `Current` class acts as a request-scoped
  depedency container, and it is also easy to mock in tests.
- A "form model", to handle creation data. It will get the plain data from the form
  and make sure all the data is handled correctly, creating locations and tags on
  the fly, and handling the identifier creation.
  We use some nice features of ActiveModel to make this object play nice with
  inputs and url helpers, and implement the `save` method to persist the data
  inside of a database transaction.
- The controller, which was generated with the scaffold command, has been modified
  to use the form model. We have also removed the JSON handlers, as we are not going
  to expose an API.
- The HTML form has been adapted to follow the DocumentCreationForm, instead of the
  persisted model.

We are not going to implement authentication, which is a complex topic and it should
be handled with extreme care, possibly having a dedicated subsystem for it. We will
assume that the current user is injected in our `Current` class by a middleware,
relying on some trusted data (like a session cookie or a JWT token).

## The "Browsing documents" feature

We now concentrate on browsing documents. The features we need to implement are:

- A list of documents, with pagination
- Filtered by tags
- Filtered by location

We proceed as before, step by step, adding only the needed code for each step to
succeed.

One important thing we have to take care is that we are going to find text in the
page, so we need unique names for the browsed documents. We defined the scenario
as

```gherkin
  Background:
    Given there are the following documents in the archive
      | Title | Location | Tags       |
      | doc1  | Basement | tag1       |
      | doc2  | Basement | tag2, tag1 |
      | doc3  | Basement | tag3       |
      | doc4  | Basement | tag1       |
      | doc5  | Basement | tag2, tag1 |
      | doc6  | Basement | tag3       |
      | doc7  | Attic    | tag1       |
      | doc8  | Attic    | tag2, tag1 |
      | doc9  | Attic    | tag3       |
      | doc10 | Attic    | tag1       |
      | doc11 | Attic    | tag2, tag1 |
```

but we are not able to use `doc1` to look for the first document, as the text matches
also the titles `doc10` and `doc11`. So for the sake of testing, we will add a zero
padding to the document titles, so we can use `doc01` to find the first document.

The rest of the implementation is trivial, we can extract a `DocumentQuery` model
and a `Page` model to handle the query result, so we can reduce the controller
complexity.
