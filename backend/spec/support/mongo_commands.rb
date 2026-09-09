# Captures the commands the Mongo driver sends while a block runs, so specs can
# assert that filtering happens in the database rather than in Ruby.
module MongoCommands
  class Subscriber
    attr_reader :commands

    def initialize
      @commands = []
    end

    def started(event)
      @commands << event
    end

    def succeeded(event)
    end

    def failed(event)
    end
  end

  def capture_mongo_commands
    subscriber = Subscriber.new
    client = Mongoid.default_client
    client.subscribe(Mongo::Monitoring::COMMAND, subscriber)

    begin
      yield
    ensure
      client.unsubscribe(Mongo::Monitoring::COMMAND, subscriber)
    end

    subscriber.commands
  end
end

RSpec.configure do |config|
  config.include MongoCommands, type: :controller
end
