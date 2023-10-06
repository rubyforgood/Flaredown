## Frontend

### Setup (one-time)
heroku stack:set heroku-20 -a flaredown-staging-webapp

heroku buildpacks:add https://github.com/lstoll/heroku-buildpack-monorepo -a flaredown-staging-webapp
heroku buildpacks:add aedev/emberjs -a flaredown-staging-webapp

heroku addons:create papertrail:choklad -a flaredown-staging-webapp

heroku config:set APP_BASE=frontend -a flaredown-staging-webapp
heroku config:set FACEBOOK_APP_ID=1 -a flaredown-staging-webapp

heroku config:set STATIC_URL=https://flaredown-staging-webapp-749110b0a96e.herokuapp.com -a flaredown-staging-webapp
heroku config:set API_HOST=https://flaredown-staging-api-fc0ece27610a.herokuapp.com -a flaredown-staging-webapp

#### Optional(?)
FULLSTORY_ENABLED:    true
FULLSTORY_ORG:        1E6EM
HEAP_KEY:             4202680434
RECAPTCHA_SITE_KEY:   6LcFXiAcAAAAAFYRuV9DN81teKBDN1IkaKI_ePj0
STATIC_URL:           https://flaredown-webapp.herokuapp.com


### Deploy
heroku config:set APP_BASE=frontend -a flaredown-staging-webapp
heroku git:remote -a flaredown-staging-webapp
git push heroku master



## Backend

### Setup (one-time)
heroku stack:set heroku-20 -a flaredown-staging-api

heroku buildpacks:add https://github.com/lstoll/heroku-buildpack-monorepo -a flaredown-staging-api
heroku buildpacks:add heroku/ruby -a flaredown-staging-api

heroku addons:create scheduler:standard -a flaredown-staging-api
heroku addons:create papertrail:choklad -a flaredown-staging-api
heroku addons:create rediscloud:30 -a flaredown-staging-api

heroku config:set APP_BASE=backend -a flaredown-staging-api
heroku config:set SYMMETRIC_ENCRYPTION_KEY_1 -a flaredown-staging-api
heroku config:set SYMMETRIC_ENCRYPTION_KEY_1_IV  -a flaredown-staging-api
heroku config:set SYMMETRIC_ENCRYPTION_PRIVATE_RSA  -a flaredown-staging-api (likely need to MANUALLY ADD QUOTES IN THE HEROKU UI)

setup mongo atlas, use the URL for MONGOLAB_URI which is what mongoid is looking for in the app

heroku git:remote -a flaredown-staging-api
git push heroku master

### JUNK?
# API_URL:              https://flaredown-api.herokuapp.com/api/
# BASE_URL:             http://app.flaredown.com/
# EMBER_ENV:            production
# FORCE_HTTPS:          true
# INTERCOM_APP_ID:      zi05kys7
# MAINTENANCE_PAGE_URL: //flaredown.com/notice.html
# MIXPANEL_KEY:         a91fa2d069b338b386b1237a2307e590
# NGINX_WORKERS:        4
# PAPERTRAIL_API_TOKEN: 1usVqvRNigx7Kxy8FRSB
# REBUILD_ALL:          true
# USERENGAGE_API_KEY:   8WVi8eE4NdqKzkDwURS2gSC4RgmFo7PIToO1SK3y5cclibMZ0JNqh6QVO6cVReMt
