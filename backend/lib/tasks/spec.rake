require_relative "../../spec/system/support/frontend_app"

namespace :spec do
  namespace :system do
    task :start_frontend do
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
