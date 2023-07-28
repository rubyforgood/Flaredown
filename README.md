# Flaredown
[![rspec](https://github.com/rubyforgood/Flaredown/actions/workflows/rspec.yml/badge.svg)](https://github.com/rubyforgood/Flaredown/actions/workflows/rspec.yml)
[![frontend](https://github.com/rubyforgood/Flaredown/actions/workflows/frontend.yml/badge.svg)](https://github.com/rubyforgood/Flaredown/actions/workflows/frontend.yml)
[![ERB lint](https://github.com/rubyforgood/Flaredown/actions/workflows/erb_lint.yml/badge.svg)](https://github.com/rubyforgood/Flaredown/actions/workflows/erb_lint.yml)
[![standardrb lint](https://github.com/rubyforgood/Flaredown/actions/workflows/ruby_lint.yml/badge.svg)](https://github.com/rubyforgood/Flaredown/actions/workflows/ruby_lint.yml)

Flaredown makes it easy for people to track symptoms over time, and learn how to control them. Our goal is to analyze the aggregate data from users of this tool to understand the probable effects of treatments and environmental stressors on chronic illness.

Help would be appreciated! Please join us in [slack #flaredown](https://rubyforgood.herokuapp.com/) or raise a github issue, or email the contact@flaredown email which is currently checked every few days.

## Environment

* PostgreSQL 12.8
* MongoDB 4.4.9 https://docs.mongodb.com/manual/tutorial/install-mongodb-on-os-x/
* Redis 6.2.3
* Ruby 2.7.4 (see [RVM](https://rvm.io/) also)
* Node 12.22.6
## Installation

_If you are running on an M1 mac, run the following command before you start the installation process:_
```bash
$env /usr/bin/arch -arm64 /bin/zsh ---login
```

_Remove all gems before you proceed_
```bash
gem uninstall -aIx
```

### Backend

On macOS, you can install libpq by running `brew install libpq && brew link --force libpq && bundle config --local build.pg "--with-ldflags=-L$(brew --prefix libpq)/lib --with-pg-include=$(brew --prefix libpq)/include"`, which is required for `bundle install` to succeed.

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

gem install foreman
```

### Frontend

```bash
cd frontend
npm install
```

## Running / Development

From the project root:
```bash
docker compose up
```

```bash
rake run
```

Visit your app at [http://localhost:4300](http://localhost:4300)

## CI

Several checks are configured to run on all commits using Github Actions, including lint, build and test steps. Definitions can be found in [./github/workflows](./github/workflows). Those checks which always run are required to be successful for PRs to be mergable.

## Deployment

Deployments target [Heroku](https://heroku.com). The traditional deployment is manually configured and is composed of two distinct applications (frontend and api) in two environments (staging and production), with automatic deployments to staging of commits to master:

* [flaredown-staging-api](https://dashboard.heroku.com/apps/flaredown-staging-api)
* [flaredown-staging-webapp](https://dashboard.heroku.com/apps/flaredown-staging-webapp) (https://app.flaredown.com)
* [flaredown-api](https://dashboard.heroku.com/apps/flaredown-api)
* [flaredown-webapp](https://dashboard.heroku.com/apps/flaredown-webapp) (https://staging.flaredown.com) (Temporarily https://flaredown-staging-webapp.herokuapp.com/login due to https://github.com/rubyforgood/Flaredown/issues/506)

Addons are used for Heroku Postgres, Heroku Redis, Heroku Scheduler + Papertrail. MongoDB is provided by mongodb.com.

## Style Guide

### 🎨 [Figma Assets](https://www.figma.com/proto/MBVn73pD6JbBkxd65KSZHr/Flaredown-Guide?page-id=0%3A1&node-id=1%3A3&viewport=241%2C48%2C0.45&scaling=contain&starting-point-node-id=1%3A3)


## License
Copyright 2015-2017 Logan Merriam and contributors.

Flaredown is open source software made available under the GPLv3 License. For details see the LICENSE file.
