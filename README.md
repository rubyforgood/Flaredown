# Flaredown
[![rspec](https://github.com/Flaredown/FlaredownEmber-2/actions/workflows/rspec.yml/badge.svg)](https://github.com/Flaredown/FlaredownEmber-2/actions/workflows/rspec.yml)
[![frontend](https://github.com/Flaredown/FlaredownEmber-2/actions/workflows/frontend.yml/badge.svg)](https://github.com/Flaredown/FlaredownEmber-2/actions/workflows/frontend.yml)
[![ERB lint](https://github.com/Flaredown/FlaredownEmber-2/actions/workflows/erb_lint.yml/badge.svg)](https://github.com/Flaredown/FlaredownEmber-2/actions/workflows/erb_lint.yml)
[![standardrb lint](https://github.com/Flaredown/FlaredownEmber-2/actions/workflows/ruby_lint.yml/badge.svg)](https://github.com/Flaredown/FlaredownEmber-2/actions/workflows/ruby_lint.yml)

Flaredown makes it easy for people to track symptoms over time, and learn how to control them. Our goal is to analyze the aggregate data from users of this tool to understand the probable effects of treatments and environmental stressors on chronic illness.

Note from April 2021: this app has not received maintenance lately but we are working to get a github actions build running so we can upgrade the heroku stack away from Cedar-14 and make other important updates. Help would be appreciated! Please join us in [slack #flaredown](https://rubyforgood.herokuapp.com/) or raise a github issue, or email the contact@flaredown email which is currently checked every few days.

## Environment

* PostgreSQL 9.4
* MongoDB 3.0.10 https://docs.mongodb.com/manual/tutorial/install-mongodb-on-os-x/
* Redis 3.2.6
* Ruby 2.6.5 (see [RVM](https://rvm.io/) also)
* Node 6.10.3


## Installation

### Backend

```bash
cd backend
echo "gem: --no-ri --no-rdoc" > ~/.gemrc
bundle install --without production -j5 --retry 10
cp env-example .env # You may adjust it however you like
                    # RVM is going to autoload this on every 'cd' to the dirrectory
bundle exec rake app:setup
```

### Frontend

```bash
cd frontend
npm install
bower install
```

## Running / Development

```bash
rake run
```

Visit your app at [http://localhost:4300](http://localhost:4300)

## License
Copyright 2015-2017 Logan Merriam and contributors.

Flaredown is open source software made available under the GPLv3 License. For details see the LICENSE file.
