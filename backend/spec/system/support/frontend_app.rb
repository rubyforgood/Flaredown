module SystemSpec
  class FrontendApp
    include Singleton

    def start(log = "/dev/null")
      if test_connection_to_frontend_app
        puts "Frontend app already running at #{frontend_app_url}"
        return
      end

      puts "Starting frontend app at #{frontend_app_url}"
      puts `pwd`
      puts `ls`
      @pid ||= Process.spawn(
        frontend_app_cmd,
        [:out, :err] => log,
        :chdir => "../frontend"
      )

      timeout = 15.seconds
      unless test_connection_to_frontend_app(timeout)
        fail "Frontend app did not start within #{timeout} seconds"
      end
    end

    def wait_on
      return unless @pid
      Process.wait @pid
    end

    def stop
      return unless @pid
      Process.kill "QUIT", @pid
      Process.wait @pid
    end

    private

    def test_connection_to_frontend_app(timeout = 0)
      system(
        test_connection_cmd(timeout),
        out: "/dev/null"
      )
    end

    def test_connection_cmd(timeout)
      [
        "curl --silent --head -X GET",
        "--retry-connrefused",
        "--retry", timeout.to_s,
        "--retry-delay", "1",
        frontend_app_url
      ].join(" ")
    end

    def frontend_app_cmd
      [
        "./node_modules/.bin/ember", "serve",
        "--port", frontend_port,
        "--proxy", "http://localhost:#{backend_port}"
      ].join(" ")
    end

    def frontend_app_url
      "http://localhost:#{frontend_port}"
    end

    def frontend_port
      ENV["SYSTEM_SPEC_FRONTEND_PORT"]
    end

    def backend_port
      ENV["SYSTEM_SPEC_BACKEND_PORT"]
    end
  end
end
