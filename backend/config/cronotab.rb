require 'rake'

Rails.app_class.load_tasks

Crono.perform(NotificationDispatcher).every 30.minutes
