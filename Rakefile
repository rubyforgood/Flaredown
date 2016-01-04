require 'rake'

desc "run application"
task :run do
  pids = [
    spawn("cd backend && rails s"),
  ]

  trap "INT" do
    Process.kill "INT", *pids
    exit 1
  end

  pids.each do |pid|
    Process.wait pid
  end
end
