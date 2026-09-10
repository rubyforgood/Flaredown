require "active_support/core_ext/integer/time"

# The test environment is used exclusively to run your application's
# test suite. You never need to work with it otherwise. Remember that
# your test database is "scratch space" for the test suite and is wiped
# and recreated between test runs. Don't rely on the data there!

Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # While tests run files are not watched, reloading is not necessary.
  config.enable_reloading = false

  # Eager loading loads your entire application. The Rails default here is
  # `ENV["CI"].present?`, which makes local and CI runs load different amounts of code.
  # Two things went wrong with that:
  #
  #   1. SimpleCov starts without `track_files`, so it only measures files that were
  #      actually loaded. Locally that silently excluded 68 app files the suite never
  #      touches, reporting 95.54% against a denominator defined by the tests
  #      themselves; CI eager-loaded those same files and reported 86.35%.
  #   2. Eager loading is what catches autoload and NameError breakage. Gating it on CI
  #      meant that whole class of bug could only ever fail on CI, never locally.
  #
  # Measured cost of always eager loading: about 0.5s on boot (2.7s -> 3.2s).
  config.eager_load = true

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

  # Run jobs through the Active Job test adapter rather than Sidekiq. Until
  # Rails 7.2, ActiveJob::TestHelper installed this itself; it now leaves an
  # explicitly-configured adapter alone (config/application.rb sets :sidekiq),
  # which silently turns perform_enqueued_jobs into a no-op.
  config.active_job.queue_adapter = :test

  # Fail on deprecation warnings rather than printing them. Deprecations are the
  # advance notice of the next framework upgrade's breakage, and on stderr they
  # scroll past unread.
  config.active_support.deprecation = :raise

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
