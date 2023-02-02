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
