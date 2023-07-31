namespace :spec do
  begin
    require "rspec/core/rake_task"

    Rake::Task[:system].clear
    RSpec::Core::RakeTask.new(:system) do |t|
      t.rspec_opts = "--tag type:system"
    end
  rescue LoadError
    # no rspec available
  end

  namespace :system do
    task :start_frontend do
      require_relative "../../spec/system/support/frontend_app"

      frontend_app = SystemSpec::FrontendApp.instance
      frontend_app.start $stdout

      trap "INT" do
        frontend_app.stop
        exit 1
      end

      frontend_app.wait_on
    end
  end
end
