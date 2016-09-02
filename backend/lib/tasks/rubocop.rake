if Rails.env.development?
  require 'rubocop/rake_task'
  RuboCop::RakeTask.new
end
