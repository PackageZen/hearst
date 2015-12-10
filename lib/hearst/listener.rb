module Hearst
  class Listener

    attr_reader :connection

    def initialize
      @connection = Bunny.new(ENV['AMQP'])
    end

    def listen
      connection.start

      channel = connection.create_channel
      channel.prefetch(1)

      # parse out queues, exchanges they should bind to, and keys they should listen for
      # hydrate a class based on routing key name from app/subscribers

      queue = channel.queue(ENV['EXCHANGE_NAME'],
                            durable: true,
                            auto_delete: false)

      queue.bind(channel.topic('pz.core'), routing_key: 'foo')

      queue.subscribe(manual_ack: true) do |delivery_info, metadata, payload|
        puts "Received message: #{payload}"
        channel.acknowledge(delivery_info.delivery_tag)
      end
    end

  end
end
