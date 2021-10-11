# Flaredown
[![rspec](https://github.com/rubyforgood/Flaredown/actions/workflows/rspec.yml/badge.svg)](https://github.com/rubyforgood/Flaredown/actions/workflows/rspec.yml)
[![frontend](https://github.com/rubyforgood/Flaredown/actions/workflows/frontend.yml/badge.svg)](https://github.com/rubyforgood/Flaredown/actions/workflows/frontend.yml)
[![ERB lint](https://github.com/rubyforgood/Flaredown/actions/workflows/erb_lint.yml/badge.svg)](https://github.com/rubyforgood/Flaredown/actions/workflows/erb_lint.yml)
[![standardrb lint](https://github.com/rubyforgood/Flaredown/actions/workflows/ruby_lint.yml/badge.svg)](https://github.com/rubyforgood/Flaredown/actions/workflows/ruby_lint.yml)

Flaredown makes it easy for people to track symptoms over time, and learn how to control them. Our goal is to analyze the aggregate data from users of this tool to understand the probable effects of treatments and environmental stressors on chronic illness.

Note from April 2021: this app has not received maintenance lately but we are working to upgrade the heroku stack away from Cedar-14 and make other important updates. Help would be appreciated! Please join us in [slack #flaredown](https://rubyforgood.herokuapp.com/) or raise a github issue, or email the contact@flaredown email which is currently checked every few days.

## Environment

* PostgreSQL 12.8
* MongoDB 4.4.9 https://docs.mongodb.com/manual/tutorial/install-mongodb-on-os-x/
* Redis 6.2.3
* Ruby 2.6.5 (see [RVM](https://rvm.io/) also)
* Node 6.10.3

You can spin up instances of the required data-stores in Docker containers using `docker compose up` in the project root.

On macOS, you can install libpq by running `brew install libpq && brew link --force libpq && bundle config --local build.pg "--with-ldflags=-L$(brew --prefix libpq)/lib --with-pg-include=$(brew --prefix libpq)/include"`, which is required for `bundle install` to succeed.

## Installation

### Backend

```bash
cd backend
echo "gem: --no-ri --no-rdoc" > ~/.gemrc
bundle config set --local without 'production'
bundle config set --local jobs 5
bundle config set --local retry 10
bundle install
cp env-example .env # You may adjust it however you like
                    # RVM is going to autoload this on every 'cd' to the directory
bundle exec rake app:setup
```

### Frontend

```bash
cd frontend
npm install
```

## Running / Development

```bash
rake run
```

Visit your app at [http://localhost:4300](http://localhost:4300)

## License
Copyright 2015-2017 Logan Merriam and contributors.

Flaredown is open source software made available under the GPLv3 License. For details see the LICENSE file.
