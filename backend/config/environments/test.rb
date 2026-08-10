require "active_support/core_ext/integer/time"

# Values the `test:` block of config/secrets.yml used to supply. Set here rather
# than in a .env file so the suite runs the same way locally, in Docker and in
# CI. This file is loaded before config/initializers, which is where
# TOMORROW_IO_KEY is read. The API key is not a real one: it has to match the
# URI recorded in the WeatherRetriever VCR cassettes.
#
# Assigned when blank rather than when nil: env-example ships SMTP_EMAIL_FROM
# with an empty value, so a developer's .env sets it to "" rather than leaving
# it unset.
ENV["TOMORROW_IO_KEY"] = "MY_MEGA_TOMORROW_IO_KEY" if ENV["TOMORROW_IO_KEY"].blank?
ENV["SMTP_EMAIL_FROM"] = "from@some.email" if ENV["SMTP_EMAIL_FROM"].blank?

# Also not real. The Facebook strategy captures these at boot, and spec/requests/
# omniauth_spec.rb signs its fbsr_<app_id> cookie with the secret.
ENV["FACEBOOK_APP_ID"] = "1234567890" if ENV["FACEBOOK_APP_ID"].blank?
ENV["FACEBOOK_APP_SECRET"] = "facebook-app-secret" if ENV["FACEBOOK_APP_SECRET"].blank?

# The test environment is used exclusively to run your application's
# test suite. You never need to work with it otherwise. Remember that
# your test database is "scratch space" for the test suite and is wiped
# and recreated between test runs. Don't rely on the data there!

Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # While tests run files are not watched, reloading is not necessary.
  config.enable_reloading = false

  # Eager loading loads your entire application. When running a single test locally,
  # this is usually not necessary, and can slow down your test suite. However, it's
  # recommended that you enable it in continuous integration systems to ensure eager
  # loading is working properly before deploying your code.
  config.eager_load = ENV["CI"].present?

  # Configure public file server for tests with Cache-Control for performance.
  config.public_file_server.enabled = true
  config.public_file_server.headers = {
    "Cache-Control" => "public, max-age=#{1.hour.to_i}"
  }

  # Show full error reports and disable caching.
  config.consider_all_requests_local = true
  config.action_controller.perform_caching = false
  config.cache_store = :null_store

  # Render exception templates for rescuable exceptions and raise for other exceptions.
  config.action_dispatch.show_exceptions = :rescuable

  # Disable request forgery protection in test environment.
  config.action_controller.allow_forgery_protection = false

  config.action_mailer.perform_caching = false

  # Tell Action Mailer not to deliver emails to the real world.
  # The :test delivery method accumulates sent emails in the
  # ActionMailer::Base.deliveries array.
  config.action_mailer.delivery_method = :test

  # Likewise, don't push Active Job work to Redis from the suite. This overrides
  # the :sidekiq adapter set in config/application.rb, and only affects the
  # Active Job path (perform_later/deliver_later); workers invoked through
  # Sidekiq's own perform_async are unaffected.
  config.active_job.queue_adapter = :test

  # Print deprecation notices to the stderr.
  config.active_support.deprecation = :stderr

  # Raise exceptions for disallowed deprecations.
  config.active_support.disallowed_deprecation = :raise

  # Tell Active Support which deprecation messages to disallow.
  config.active_support.disallowed_deprecation_warnings = []

  # Raises error for missing translations.
  # config.i18n.raise_on_missing_translations = true

  # Annotate rendered view with file names.
  # config.action_view.annotate_rendered_view_with_filenames = true

  # Raise error when a before_action's only/except options reference missing actions
  config.action_controller.raise_on_missing_callback_actions = true

  config.after_initialize do
    Bullet.enable = true
    Bullet.bullet_logger = true
    Bullet.raise = true # raise an error if n+1 query occurs
  end
end
