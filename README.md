# rundfunk-mitbestimmen

[![Build
Status](https://travis-ci.org/roschaefer/rundfunk-mitbestimmen.svg?branch=master)](https://travis-ci.org/roschaefer/rundfunk-mitbestimmen)

### Problem

**Public broadcasting in Germany receives *€8,000,000,000* (eight billion
euros) annually, yet it is subject to no public feedback, ranking, or
even debate on what constitutes value or quality.**

### Solution
**On [rundfunk-mitbestimmen.de](http://rundfunk-mitbestimmen.de/) you can
say how your €17.50 per month should be spent. It is a proof of concept how
digital democracy can work for publicly funded media and it is a win-win situation
for both sides: More influence for the audience. More data for broadcasters.**

## Community

Rundfunk mitbestimmen is maintained by the community. We have regular meetings, run online pair-programmings and tutorials in our [online learner community at Agile Ventures](https://www.agileventures.org/projects/rundfunk-mitbestimmen). You can [join our Slack here](https://www.agileventures.org/users/sign_up) and then find us in our channel [#rundfunk-mitbestimmen](https://agileventures.slack.com/app_redirect?channel=rundfunk-mitbestimmen). Here is the Youtube Playlist of our recent meetings or pair-programmings:


[![Community pair-programming/meeting](https://img.youtube.com/vi/D_g6UHMC8NU/sddefault.jpg)](https://www.youtube.com/embed/videoseries?list=PL1CiawkXA01MwjAVBzV0fRjpbl454SCbl)


## Directory Layout

This repository contains three important folders:

1. [frontend](https://github.com/roschaefer/rundfunk-mitbestimmen/tree/master/frontend) (EmberJS)
2. [backend](https://github.com/roschaefer/rundfunk-mitbestimmen/tree/master/backend) (Ruby on Rails)
3. [features](https://github.com/roschaefer/rundfunk-mitbestimmen/tree/master/features) (Cucumber/Capybara)


### Backend

The backend is responsible to store the data. Who wants to pay for which
broadcast and how much? Users are related to broadcasts via `impressions` in the
database. The `response` on the impression model can be either `negative`,
`neutral` and `positive` and indicates whether a user wants to give money to a
broadcast. If the `response` is positive, the `amount` further specifies how
much to pay for a broadcast. So, the sum of all amounts per user must not exceed
the monthly fee of 17,50€ per month.

![ER diagram](https://github.com/roschaefer/rundfunk-mitbestimmen/blob/master/documentation/images/er.png)

### Frontend

The frontend should be as easy to use as possible. The user can
login and register, fetch a set of not yet voted broadcasts, decide about
broadcasts, assign money and see the public statistics. Most of these
actions will send requests to the backend. The frontend should be comfortable to
use, e.g. by default amounts are evenly distributed with the option to set the
amount explicitly.

![Process diagram](https://github.com/roschaefer/rundfunk-mitbestimmen/blob/master/documentation/images/process.png)

### Features

We do full stack testing with Cucumber and Capybara. We specify the
requirements as user stories in our Github issues and implement them as cucumber
features. The cucumber features are a good starting for you to understand the
current behaviour and the reasoning behind it.

Here is our model how to write tests. The cucumber tests are at the top. As they
test the entire stack, cucumber tests tend to be rather slow in execution but
in return they deliver some confidence that the system works.
![Testing pyramid](https://github.com/roschaefer/rundfunk-mitbestimmen/blob/master/documentation/images/testing-pyramid.png)

## Installation and Usage with Docker

Make sure you have `docker` and `docker-compose` installed:
```sh
$ docker --version
Docker version 18.05.0-ce, build f150324782
$ docker-compose --version
docker-compose version 1.22.0, build unknown
```

Clone the repository:
```sh
git clone https://github.com/roschaefer/rundfunk-mitbestimmen.git
```

You can setup the development environment with:

```sh
cd rundfunk-mitbestimmen
docker-compose up
```

This can take a while...
As soon as this is finished, create the database and run migrations with:
```sh
docker-compose run --rm backend bin/rails db:create db:migrate
```

App is running on [localhost:4200](http://localhost:4200/)

If you want, you can create some seed data
```sh
docker-compose run --rm backend bin/rails db:seed
```

Run frontend tests:
```sh
docker-compose run --rm frontend ember test
```

Run backend tests:
```sh
docker-compose run --rm backend bin/rspec
```

For fullstack testing, use the provided [docker-compose override](https://docs.docker.com/compose/extends/#example-use-case):
```sh
docker-compose -f docker-compose.yml -f docker-compose.fullstack-testing.yml up
```
When all containers are up, run the cucumber tests in the `fullstack` service with:
```sh
docker-compose run --rm fullstack bundle exec cucumber
```
## Local Installation

Make sure that you have a recent version of [node](https://nodejs.org/en/),
[yarn](https://yarnpkg.com/en/),
[EmberJS](https://www.emberjs.com/), [ruby](https://www.ruby-lang.org/en/)
and [postgresql](https://www.postgresql.org/) installed before you proceed. E.g.
we have the following versions:

```sh
$ node --version
v10.4.1
$ yarn --version
1.7.0
$ ember --version
ember-cli: 3.1.4
node: 10.4.1
os: linux x64

$ ruby --version
ruby 2.4.1p111 (2017-03-22 revision 58053) [x86_64-linux]
$ psql --version
psql (PostgreSQL) 9.6.5
```

### Clone the repository:
```sh
git clone https://github.com/roschaefer/rundfunk-mitbestimmen.git
```

### Install dependencies and run migrations:
1. Install dependencies for full stack testing
```sh
cd rundfunk-mitbestimmen
bundle
```

2. Install frontend dependencies
```sh
cd frontend
yarn install
```

3. Install backend dependencies
```sh
cd ../backend
bundle
```
4. Setup the database

**(OPTIONAL):** Customize the file `backend/config/database.yml` to match your local database configuration.

Now create the databases and run the migrations:
```sh
bin/rails db:create db:migrate
```

5. If you want, you can create some seed data
```
cd backend
bin/rails db:seed
cd ..
```


## Usage

Start the backend and sidekiq:
```sh
cd backend && bin/rails s
```
```sh
cd backend && bundle exec sidekiq -q default -q mailers
```

Open another terminal and start the frontend:
```sh
cd frontend && ember server
```

App is running on [localhost:4200](http://localhost:4200/)

## Full stack testing

Run the frontend server:
```sh
cd frontend && ember server --environment=fullstack
```

Open two more terminals and run the backend server and sidekiq:
```sh
cd backend && bin/rails server --environment=fullstack
```
```sh
cd backend && bundle exec sidekiq
```

Open yet another terminal and run the tests:
```sh
bundle exec cucumber
```

These environments serve the purpose to

1. Stub out external services in the frontend, e.g. authentication
   via Auth0.
2. Use a separate test database in the backend, which will be cleaned after each
   test run.

If you want to run chrome or firefox instead of headless chrome, you can set an
environment variable:
```sh
bundle exec cucumber DRIVER=chrome
```
or
```sh
bundle exec cucumber DRIVER=firefox
```

### Frontend tests

```sh
cd frontend && ember test --server
```

### Backend tests

```sh
cd backend && bin/rspec
```

## Guidelines

[See our detailed contribution guidelines :mag:](/CONTRIBUTING.md)


We use this [project board](https://github.com/roschaefer/rundfunk-mitbestimmen/projects/1) as our central issue tracker. Issues are ordered by priority and you can filter for `good first issue` if you are interested in a beginner-friendly task.
Additionally, issues are tagged with `backend` and `frontend` depending on where code needs to be changed.

### Auth0

Don't be afraid of our identity provider [Auth0](https://auth0.com/). In
development environment your login will reach the "rundfunk-testing" instance
of Auth0. This will not pollute the Auth0 instance used in production.

### Workflow for Behaviour Driven Development with Cucumber:

1. Fork it :fork_and_knife:
2. Pick an issue from the [backlog](https://github.com/roschaefer/rundfunk-mitbestimmen/projects/1)
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
