terraform {
  required_providers {
    heroku = {
      source = "heroku/heroku"
      version = "~> 4.6"
    }

    herokux = {
      source = "davidji99/herokux"
      version = "0.30.4"
    }
  }
}

provider "heroku" {}
provider "herokux" {}

variable "heroku_prefix" {
  type = string
  default = ""
}

resource "heroku_app" "staging" {
  name = "${var.heroku_prefix}flaredown-staging"

  # acm = true
  buildpacks = [
    "https://github.com/lstoll/heroku-buildpack-monorepo",
    "heroku/ruby"
  ]
  stack = "heroku-18"
  region = "us"
}

resource "heroku_addon" "postgres" {
  app = heroku_app.staging.name
  plan = "heroku-postgresql:hobby-dev"
}

resource "heroku_addon_attachment" "postgres" {
  app_id  = heroku_app.staging.id
  addon_id = heroku_addon.postgres.id
}

# resource "heroku_addon" "redis" {
#   app = heroku_app.staging.name
#   plan = "heroku-redis:hobby-dev"
# }

# resource "heroku_addon_attachment" "redis" {
#   app_id  = heroku_app.staging.id
#   addon_id = heroku_addon.redis.id
# }

resource "heroku_pipeline" "flaredown-pipeline" {
  name = "${var.heroku_prefix}flaredown-pipeline"
}

resource "herokux_pipeline_github_integration" "flaredown-pipeline-github" {
  pipeline_id = heroku_pipeline.flaredown-pipeline.id
  org_repo = "rubyforgood/Flaredown"
}

resource "heroku_pipeline_coupling" "staging" {
  app = heroku_app.staging.name
  pipeline = heroku_pipeline.flaredown-pipeline.id
  stage = "staging"
}
