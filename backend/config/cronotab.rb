require 'rake'

Rails.app_class.load_tasks

Crono.perform(NotificationDispatcher).every((Rails.env.production? ? 30 : 3).minutes)
