# Contributing to Rundfunk MITBESTIMMEN

:+1::tada: First off, thanks for taking the time to contribute! :tada::+1:

Development Process
------------------

Our default working branch is `master`. We do work by creating branches off `master` for new features and bugfixes. Any feature should include appropriate Cucumber acceptance tests alonng with RSpec unit tests for the backend and Mocha tests for the frontend. A bugfix may include an acceptance test depending on where the bug occurred, but fixing a bug should start with the creation of a test that replicates the bug, so that any bugfix submission will include an appropriate test as well as the fix itself.

Each developer will usually work with a [fork](https://help.github.com/articles/fork-a-repo/) of the [main repository](https://github.com/roschaefer/rundfunk-mitbestimmen). Before starting work on a new feature or bugfix, please ensure you have [synced your fork to upstream/develop](https://help.github.com/articles/syncing-a-fork/):

```
git pull upstream master
```

Note that you should be re-syncing daily (even hourly at very active times) on your feature/bugfix branch to ensure that you are always building on top of very latest develop code.

Every pull request should be for a corresponding GitHub issue.

Please ensure that each commit in your pull request makes a single coherent change and that the overall pull request only includes commits related to the specific GitHub issue that the pull request is addressing. This helps the project managers understand the PRs and merge them more quickly.

Whatever you are working on, or however far you get please do open a "Work in Progress" (WIP) [pull request](https://help.github.com/articles/creating-a-pull-request/) (just prepend your PR title with "[WIP]" ) so that others in the team can comment on your approach. Even if you hate your horrible code :-) please throw it up there and we'll help guide your code to fit in with the rest of the project.


Before you make a pull request it is a great idea to sync again to the upstream develop branch to reduce the chance that there will be any merge conflicts arising from other PRs that have been merged to develop since you started work:

```
git pull upstream master
```

In your pull request description please include a sensible description of your code and a tag `fixes #<issue-id>` e.g. :

```
This PR adds a CONTRIBUTING.md file and a docs directory
fixes #799
```

which will associate the pull request with the issue in GitHub.

See also [more details on submitting pull requests](https://github.com/AgileVentures/WebsiteOne/blob/develop/docs/how_to_submit_a_pull_request_on_github.md).

Pull Request Review
-------------------

The project managers will review your pull request as soon as possible.

The project managers will review the pull request for coherence with the specified feature or bug fix, and give feedback on code quality, user experience, documentation and git style. Please respond to comments from the project managers with explanation, or further commits to your pull request in order to get merged in as quickly as possible.

To maximize flexibility add the project managers as collaborators to your fork of the project in order to allow them to help you fix your pull request, but this is not required.

Code Style
-------------

For the frontend we use [JSHint](http://jshint.com/), in the backend we have [rubocop](https://github.com/bbatsov/rubocop) based on the [Ruby Style Guide](https://github.com/bbatsov/ruby-style-guide). JSHint and rubocop are both included in our [build pipeline](https://github.com/roschaefer/rundfunk-mitbestimmen/blob/master/.travis.yml), any offending code in a pull request will [break our build server](https://travis-ci.org/roschaefer/rundfunk-mitbestimmen) and you get a notification. If you want to check before you submit the pull request, just run `bundle exec rubocop` in the backend and `ember test` in the frontend.
