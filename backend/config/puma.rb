#!/usr/bin/env puma

# Load "path" as a rackup file.
#
# The default is "config.ru".
#
rackup DefaultRackup

port ENV['PORT'] || 3000
environment ENV['RACK_ENV'] || 'development'

# === Cluster mode ===

# How many worker processes to run.
#
# The default is "0".
#
workers Integer(ENV['WEB_CONCURRENCY'] || 2)

# Configure "min" to be the minimum number of threads to use to answer
# requests and "max" the maximum.
#
# The default is "0, 16".
#
threads_count = Integer(ENV['MAX_THREADS'] || 5)
threads threads_count, threads_count

# Preload the application before starting the workers; this conflicts with
# phased restart feature. (off by default)
preload_app!

on_worker_boot do
  # Worker specific setup for Rails 4.1+
  # See: https://devcenter.heroku.com/articles/deploying-rails-applications-with-the-puma-web-server#on-worker-boot
  ActiveRecord::Base.establish_connection
end
