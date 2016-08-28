# rundfunk-mitbestimmen
[![Build
Status](https://travis-ci.org/roschaefer/rundfunk-mitbestimmen.svg?branch=master)](https://travis-ci.org/roschaefer/rundfunk-mitbestimmen)

Since 2013, every household in Germany has to pay fees for public
broadcasting without legal opt-out.
If we have to pay after all, it would be great to say where the money
should go to.
``rundfunk-mitbestimmen`` is a voting tool to enable participation:
How much money should go to which tv or radio broadcast?

## Demo

Visit [rundfunk-mitbestimmen](http://rundfunk-mitbestimmen.surge.sh/) on surge 

## Structure

This repository serves as a meta-repository for the frontend and backend
of the `rundfunk-mitbestimmen` app. It is the place for user
requirements and general documentation. It also contains acceptance
tests as they need to be run against the entire stack.

## Process explanation

Both applications have different purposes:

The backend is responsible to store the information which user likes which
broadcast and how much of the monthly contributions should be
assigned. In the database users are related to broadcasts via
selections. The attribute `response` on the selection model can be either
`negative`, `neutral` and `positive` and indicates whether someone wants to give
money to a broadcast at all. The `amount` defines the precise amount someone
wants to pay for a broadcast. The sum of all amounts per user must be within
zero and 17,50€ per month.

![ER diagram](/documentation/images/er.png)

The frontend is responsible for an easy interaction with the backend.
First, it selects a subset of relevant broadcasts from a huge collection of
available broadcasts. Second, the user has to decide on every selected
broadcast whether to give money or not. For all broadcasts that were
chosen, the user can specifiy a certain amount in the third step. The
individual invoices of all users are accumulated and published on a
public balances page. If desired, the user can now adjust his individual invoice
or add more broadcasts to the invoice. The user can repeat this process as often
as desired.

![Process diagram](/documentation/images/process.png)

## Installation

This repository contains both applications as git submodules:

1. [rundfunk-frontend](https://github.com/roschaefer/rundfunk-frontend) (ember app)
2. [rundfunk-backend](https://github.com/roschaefer/rundfunk-backend) (rails - api only)

Make sure that you have a recent version of [ember.js](http://emberjs.com/) and
[rails](http://rubyonrails.org/) installed before you proceed. E.g. we have the
following versions:

```
ember-cli: 2.7.0
node: 6.2.1
Rails 5.0.0.1
ruby 2.3.1
```

Clone the repository:
```
git clone https://github.com/roschaefer/rundfunk-mitbestimmen.git
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

## Testing

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

### Backend tests

```
cd backend
bin/rspec
```

### Frontend tests

```
cd frontend
ember test --serve
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
