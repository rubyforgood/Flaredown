#!/usr/bin/env puma

# Load "path" as a rackup file.
#
# The default is "config.ru".
#
rackup DefaultRackup

port Integer(ENV.fetch('PORT') { 3000 })
environment ENV.fetch('RACK_ENV') { 'development' }

# Configure "min" to be the minimum number of threads to use to answer
# requests and "max" the maximum.
#
# The default is "0, 16".
#
threads_count = Integer(ENV.fetch('MAX_THREADS') { 16 })
threads threads_count, threads_count

# Preload the application before starting the workers; this conflicts with
# phased restart feature. (off by default)
preload_app!


# === Cluster mode ===

# How many worker processes to run.
#
# The default is "0".
#
workers Integer(ENV.fetch('WEB_CONCURRENCY') { 0 })

before_fork do
  ActiveRecord::Base.connection_pool.disconnect!
end

on_worker_boot do
  # Worker specific setup for Rails 4.1+
  # See: https://devcenter.heroku.com/articles/deploying-rails-applications-with-the-puma-web-server#on-worker-boot
  ActiveSupport.on_load(:active_record) do
    ActiveRecord::Base.establish_connection
  end
end
