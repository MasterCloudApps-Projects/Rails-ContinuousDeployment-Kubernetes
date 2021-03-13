# frozen_string_literal: true

module ConnectionPoolRabbit
  # Class to connect to rabbitmq properly, puma have threads
  class Connection
    include Singleton
    attr_reader :connection

    def initialize
      @connection = Bunny.new("amqp://guest:guest@localhost:5672")
      @connection.start
    end

    def channel
      @channel ||= ConnectionPool.new do
        connection.create_channel
      end
    end
  end
end
