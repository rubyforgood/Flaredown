# flaredown


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

Visit your app at [http://localhost:4200](http://localhost:4200)

