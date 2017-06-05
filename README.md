# rundfunk-mitbestimmen

[![Join the chat at https://gitter.im/rundfunk-mitbestimmen/Lobby](https://badges.gitter.im/rundfunk-mitbestimmen/Lobby.svg)](https://gitter.im/rundfunk-mitbestimmen/Lobby?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)
[![Build
Status](https://travis-ci.org/roschaefer/rundfunk-mitbestimmen.svg?branch=master)](https://travis-ci.org/roschaefer/rundfunk-mitbestimmen)

Public broadcasting in Germany receives *€8,000,000,000* (eight billion
euros) annually, yet it is subject to little or no public feedback, ranking, or
even debate on what constitutes value or quality.

We want to change that: With this app you can make your voice heard and propose
on which shows your €17.50 per month should be spent.


## Live App

Visit [rundfunk-mitbestimmen.de](http://rundfunk-mitbestimmen.de/)

## Structure

This repository contains three important folders:

1. [frontend](https://github.com/roschaefer/rundfunk-mitbestimmen/tree/master/frontend) (EmberJS)
2. [backend](https://github.com/roschaefer/rundfunk-mitbestimmen/tree/master/backend) (Ruby on Rails)
3. [features](https://github.com/roschaefer/rundfunk-mitbestimmen/tree/master/features) (Cucumber/Capybara)


### Backend

The backend is responsible to store the data. Who wants to pay for which
broadcast and how much? Users are related to broadcasts via `selections` in the
database. The `response` on the selection model can be either `negative`,
`neutral` and `positive` and indicates whether a user wants to give money to a
broadcast. If the `response` is positive, the `amount` further specifies how
much to pay for a broadcast. So, the sum of all amounts per user must not exceed
the monthly fee of 17,50€ per month.

![ER diagram](/documentation/images/er.png)

### Frontend

The frontend should be as easy to use as possible. The user can
login and register, fetch a set of not yet voted broadcasts, decide about
broadcasts, assign money and see the public statistics. Most of these
actions will send requests to the backend. The frontend should be comfortable to
use, e.g. by default amounts are evenly distributed with the option to set the
amount explicitly.

![Process diagram](/documentation/images/process.png)

### Features

We do full stack testing with Cucumber and Capybara. We specify the
requirements as user stories in our Github issues and implement them as cucumber
features. The cucumber features are a good starting for you to understand the
current behaviour and the reasoning behind it.


## Installation and Usage with Docker (quick but without software tests)

Clone the repository:
```sh
git clone https://github.com/roschaefer/rundfunk-mitbestimmen.git
```

If you have `docker-compose` installed, you can install `frontend`,
`backend` and `db` with a single command:

```sh
dev/reset
```

After the installation, you can start the entire stack with:
```sh
dev/start
```
App is running on [localhost:4200](http://localhost:4200/)

If you want, you can create some seed data
```
docker-compose run backend bin/rails db:seed
```


## Local Installation (best option for developers)

Make sure that you have a recent version of [npm](https://www.npmjs.com/) and
[ruby](https://www.ruby-lang.org/en/) and [EmberJS](https://www.emberjs.com/)
installed before you proceed. E.g. we have the following versions:

```sh
npm --version
# 5.0.1
ruby --version
#ruby 2.4.1p111 (2017-03-22 revision 58053) [x86_64-linux]
ember --version
# WARNING: Node v8.0.0 is not tested against Ember CLI on your platform. We recommend that you use the most-recent "Active LTS" version of Node.js.
# ember-cli: 3.13.2
# node: 8.0.0
# os: linux x64
```

Clone the repository:
```sh
git clone https://github.com/roschaefer/rundfunk-mitbestimmen.git
```

Install dependencies and run migrations:
```sh
bundle

cd frontend
npm install
bower install

cd ../backend
bundle
bin/rails db:create db:migrate
cd ..
```

If you want, you can create some seed data
```
cd backend
bin/rails db:seed
cd ..
```


## Usage

Start the backend:
```sh
cd backend && bin/rails s
```

Open another terminal and start the frontend:
```sh
cd frontend && ember server
```

App is running on [localhost:4200](http://localhost:4200/)

## Full stack testing

Run:
```sh
cd frontend && ember server --environment=integration
```

Open another terminal and run:
```sh
cd backend && bin/rails server --environment=test
```

Open yet another terminal and run:
```sh
bundle exec cucumber
```

These environments serve the purpose to
1. Stub out external services in the frontend, e.g. authentication
   via Auth0.
2. Use a separate test database in the backend, which will be cleaned after each
   test run.

If you want to run firefox instead of chrome, you can set an environment
variable:
```sh
BROWSER=selenium bundle exec cucumber
```

### Frontend tests

```sh
cd frontend && ember test --server
```

### Backend tests

```sh
cd backend && bin/rspec
```

## Contributing

We use this [milestone](https://github.com/roschaefer/rundfunk-mitbestimmen/milestone/1) as priority queue for issues.

High prioritized issues will go to the top. Issues are tagged with
`backend` and `frontend` depending on where code needs to be changed.

Because GitHub lacks functionality to display estimation hours, we use [Zenhub's browser plugin](https://www.zenhub.com/).
Installing this plugin will show you the estimated hours per issue.

Don't be afraid about Auth0. As long as your local installation runs in
development environment your login will reach the "Testing" database
of Auth0. This will not pollute the production database of Auth0.

### Workflow for contributing:

1. Fork it :fork_and_knife:
2. Pick a user story from the [backlog](https://github.com/roschaefer/rundfunk-mitbestimmen/milestone/1)
3. Create your feature branch: `git checkout -b [issue number]_my_new_feature_branch`
4. Create`features/[site of change]/your.feature` and copy+paste the feature description from GitHub
5. Boot both frontend and backend as described in the [section about testing](https://github.com/roschaefer/rundfunk-mitbestimmen#full-stack-testing)
6. Run `bundle exec cucumber`
7. Append the terminal output to `features/step_definitions/steps.rb` and write expectations
8. Run `bundle exec cucumber` - tests should fail
9. Implement the feature
10. Run `bundle exec cucumber` - tests should pass
11. Commit your changes: `git commit -am 'Add some feature'`
12. Push to the branch: `git push origin -u [issue number]_my_new_feature_branch`
13. Submit a pull request :heart:

[See our detailed contribution guidelines :mag:](/CONTRIBUTING.md)

## Deployment

Our [build server Travis CI](https://travis-ci.org/roschaefer/rundfunk-mitbestimmen) takes care about automatic deployment.
Approximately 15 minutes after your pull request was merged into master, you should see the changes in production.


## Useful Links

* [ember.js](http://emberjs.com/)
* [ember-cli](http://ember-cli.com/)
* Development Browser Extensions
  * [ember inspector for chrome](https://chrome.google.com/webstore/detail/ember-inspector/bmdblncegkenkacieihfhpjfppoconhi)
  * [ember inspector for firefox](https://addons.mozilla.org/en-US/firefox/addon/ember-inspector/)


## License

See the [LICENSE](LICENSE.md) file for license rights and limitations
(MIT).
