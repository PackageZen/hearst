require 'singleton'

module Hearst
  class Dispatcher
    include Singleton

    def initialize
      connection.start
    end

    def connection
      @connection ||= Bunny.new(host)
    end

    def host
      ENV['AMQP_HOST']
    end

    def channel
      @channel ||= connection.create_channel
    end

    def exchange
      @exchange ||= channel.topic(exchange_name)
    end

    def exchange_name
      ENV['EXCHANGE_NAME']
    end
  end
end
