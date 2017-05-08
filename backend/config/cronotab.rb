require 'rake'

Rails.app_class.load_tasks

Crono.perform(NotificationDispatcher).every(3.minutes)
