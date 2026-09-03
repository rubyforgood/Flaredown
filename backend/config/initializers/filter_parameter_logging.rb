# Be sure to restart your server when you modify this file.

# Configure parameters to be partially matched (e.g. passw matches password) and filtered from the log file.
# Use this to limit dissemination of sensitive information.
# See the ActiveSupport::ParameterFilter documentation for supported notations and behaviors.
location_filters = [:postal_code, :latitude, :longitude]

Rails.application.config.filter_parameters += [
  :password, :passw, :secret, :token, :_key, :crypt, :salt, :certificate, :otp, :ssn,
  *location_filters
]

# Active Record filters SQL bind values separately from request parameters.
ActiveRecord::Base.filter_attributes += location_filters
