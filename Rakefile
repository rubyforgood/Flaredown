require 'rake'

desc "run application"
task :run do
  pids = [
    spawn("cd backend && foreman start -f Procfile.local"),
    spawn("cd frontend && rm -rfd ./dist && ./node_modules/.bin/ember serve --port 4300 --proxy http://localhost:3000")
  ]

  trap "INT" do
    Process.kill "INT", *pids
    exit 1
  end

  pids.each do |pid|
    Process.wait pid
  end
end

namespace :production do
  desc "restart application"
  task :restart do
    system("heroku restart --app flaredown-api")
  end

  desc "deploy application"
  task :deploy do
    system("git subtree push --prefix backend git@heroku.com:flaredown-api.git master")
    system("git subtree push --prefix frontend git@heroku.com:flaredown-webapp.git master")
  end

  desc "setup application"
  task :setup do
    system("heroku pg:reset DATABASE --app flaredown-api --confirm flaredown-api")
    system("heroku run rake app:setup --app flaredown-api")
  end

  desc "invite user to join into application"
  task :invite do
    system("heroku run rake app:invite --app flaredown-api")
  end

end

namespace :staging do
  desc "restart application"
  task :restart do
    system("heroku restart --app flaredown-staging-api")
  end

  desc "deploy application"
  task :deploy do
    system("git subtree push --prefix backend git@heroku.com:flaredown-staging-api.git master")
    system("git subtree push --prefix frontend git@heroku.com:flaredown-staging-webapp.git master")
  end

  desc "setup application"
  task :setup do
    system("heroku pg:reset DATABASE --app flaredown-staging-api --confirm flaredown-staging-api")
    system("heroku run rake app:setup --app flaredown-staging-api")
  end

  desc "invite user to join into application"
  task :invite do
    system("heroku run rake app:invite --app flaredown-staging-api")
  end

end
