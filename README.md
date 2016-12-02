# rundfunk-mitbestimmen

[![Join the chat at https://gitter.im/rundfunk-mitbestimmen/Lobby](https://badges.gitter.im/rundfunk-mitbestimmen/Lobby.svg)](https://gitter.im/rundfunk-mitbestimmen/Lobby?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)
[![Build
Status](https://travis-ci.org/roschaefer/rundfunk-mitbestimmen.svg?branch=master)](https://travis-ci.org/roschaefer/rundfunk-mitbestimmen)

Since 2013, every household in Germany has to pay fees for public
broadcasting without any legal opt-out.

We think this is a great example for a "cultural flatrate", a system where
every citizen must pay a certain amount on a regular basis and the money gets
re-distributed to authors of creative content e.g. music, films, books,
podcasts, newspapers, software etc. Only question: Who should decide who
gets how much and for what?

Well, we let **YOU** decide!

That's right, who could decide better about the quality of content than
the consumer?

In Germany, certain broadcasting councils have the exclusive rights to
determine our TV and radio programme and to govern the mind-boggling amount of
*€8,000,000,000* every year.

We want to change that: With this app you can make your voice heard and propose
on which shows your €17.50 per month should be spent.


## Live App

Visit [rundfunk-mitbestimmen.de](http://rundfunk-mitbestimmen.de/)

## Structure

This repository serves as meta-repository for both frontend and backend. We
track user requirements and general documentation here. It contains acceptance
tests as they need to be run against the entire stack.

## Process explanation

The backend is responsible to store the data. Who wants to pay for which
broadcast and how much? Users are related to broadcasts via `selections` in the
database. The `response` on the selection model can be either `negative`,
`neutral` and `positive` and indicates whether a user wants to give money to a
broadcast. If the `response` is positive, the `amount` further specifies how
much to pay for a broadcast. So, the sum of all amounts per user must not exceed
the monthly fee of 17,50€ per month.

![ER diagram](/documentation/images/er.png)

The frontend should be as easy to use as possible. The user can
login and register, fetch a set of not yet voted broadcasts, decide about
broadcasts, assign money and see the public balances. Most of these
actions will send requests to the backend. The app should keep the required user
action to a minimum. E.g. on the invoice page, amounts are evenly distributed
with the option to set the amount explicitly.

![Process diagram](/documentation/images/process.png)

## Installation

This repository contains both applications as git submodules:

1. [rundfunk-frontend](https://github.com/roschaefer/rundfunk-frontend) (ember app)
2. [rundfunk-backend](https://github.com/roschaefer/rundfunk-backend) (rails - api only)

Make sure that you have a recent version of [ember.js](http://emberjs.com/) and
[rails](http://rubyonrails.org/) installed before you proceed. E.g. we have the
following versions:

```
ember-cli: 2.9.1
node: 6.2.1
Rails 5.0.0.1
ruby 2.3.1
```

Clone the repository recursively with all submodules:
```
git clone --recursive https://github.com/roschaefer/rundfunk-mitbestimmen.git
```

Install dependencies and run migrations:
```
cd rundfunk-mitbestimmen
bundle
gem install foreman

cd frontend
ember install

cd ../backend
bundle
bin/rails db:create db:migrate db:seed
cd ..
```


## Usage

Start the server:
```
foreman start
```

App is running on [localhost:4200](http://localhost:4200/)

## Full stack testing

Run:
```
bundle exec cucumber
```

Tip: If you're running a recent version of firefox (e.g. 48.0) you will
experience an `Unable to obtain stable firefox connection`. You can run
chrome as an alternative to downgrading firefox:
```
BROWSER=chrome bundle exec cucumber
```

### Frontend tests

```
cd frontend
ember test --serve
```

### Backend tests

```
cd backend
bin/rspec
```

## Contributing

1. Fork it!
2. Create your feature branch: `git checkout -b my-new-feature`
3. Commit your changes: `git commit -am 'Add some feature'`
4. Push to the branch: `git push origin my-new-feature`
5. Submit a pull request :heart:


## License

See the [LICENSE](LICENSE.md) file for license rights and limitations
(MIT).
