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
cucumber --init
```

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
