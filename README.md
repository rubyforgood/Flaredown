# Flaredown
Flaredown makes it easy for people to track symptoms over time, and learn how to control them. Our goal is to analyze the aggregate data from users of this tool to understand the probably effects of treatments and environmental stressors on chronic illness.

## Installation

### Backend

    cd backend
    bundle install --without production
    cp env-example .env
    bundle exec rake app:setup

### Frontend

    cd frontend
    npm install
    bower install

## Running / Development

    rake run

Visit your app at [http://localhost:4300](http://localhost:4300)

## License
Copyright 2015-2017 Logan Merriam and contributors.

Flaredown is open source software made available under the GPLv3 License. For details see the LICENSE file.
