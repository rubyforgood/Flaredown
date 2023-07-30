require 'rake'

desc "run application"
task :run do
  pids = [
    spawn("cd backend && bundle install && foreman start -f Procfile.local"),
    spawn("cd frontend && rm -rfd ./dist && ./node_modules/.bin/ember serve --port 4300")
  ]

  trap "INT" do
    Process.kill "INT", *pids
    exit 1
  end

  pids.each do |pid|
    Process.wait pid
  end
end

{ production: 'flaredown', staging: 'flaredown-staging'}.each do |env, application|
  namespace env.to_sym do
    desc "restart application"
    task :restart do
      log "Restart #{application}"
      restart "#{application}-api"
    end

    desc "deploy application"
    task :deploy do
      Rake::Task["#{env.to_s}:deploy:backend"].invoke
      Rake::Task["#{env.to_s}:deploy:frontend"].invoke
    end

    namespace :deploy do
      desc "deploy frontend application"
      task :frontend do
        log "Deploy frontend #{application} with revision: #{revision}"
        deploy_to "git@heroku.com:#{application}-webapp.git",  'frontend'
      end

      desc "deploy backend application"
      task :backend do
        log "Deploy backend #{application} with revision: #{revision}"
        deploy_to "git@heroku.com:#{application}-api.git",  'backend'
        migrate "#{application}-api"
      end
    end

    desc "setup application"
    task :setup do
      system("heroku pg:reset DATABASE --app #{application}-api --confirm #{application}-api")
      system("heroku run rake app:setup --app #{application}-api")
    end

    desc "invite user to join into application"
    task :invite do
      system("heroku run rake app:invite --app #{application}-api")
    end
  end

end

def deploy_to(remote, subtree)
  system("git push #{remote} `git subtree split --prefix #{subtree} #{revision}`:master --force")
end

def migrate(application)
  system("heroku run rake db:migrate --app #{application}")
end

def restart(application)
  system("heroku restart --app #{application}")
end

def revision
  ENV.fetch('REVISION') {'master'}
end

def log(message)
  puts ">>> #{message}"
end
