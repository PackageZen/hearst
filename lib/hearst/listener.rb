module Hearst
  class Listener

    attr_reader :connection

    def initialize
      @connection = Bunny.new(ENV['AMQP_HOST'])
    end

    def listen
      connection.start

      subscribers.each do |subscriber|
        Hearst::Logging.logger.info "Binding #{subscriber.name} to #{subscriber.exchange}"
        queue.bind(exchange_for(subscriber.exchange), routing_key: subscriber.event)
      end

      queue.subscribe(manual_ack: true) do |delivery_info, metadata, payload|
        subscriber = subscriber_for(event: delivery_info.routing_key, exchange: delivery_info.exchange)
        if subscriber && subscriber.process(payload)
          Hearst::Logging.logger.info "#{subscriber.name} processed #{delivery_info.routing_key} from #{delivery_info.exchange}"
          channel.acknowledge(delivery_info.delivery_tag)
        else
          channel.nack(delivery_info.delivery_tag, false, true)
        end
      end
    end

    def subscriber_for(event: nil, exchange: nil)
      subscribers.select { |sub| sub.exchange == (exchange || exchange_name) && sub.event == event }.first
    end

    def channel
      @channel ||= connection.create_channel.tap do |chnl|
        chnl.prefetch(1)
      end
    end

    def queue
      @queue ||= channel.queue(exchange_name, durable: true, auto_delete: false)
    end

    def exchange_for(name)
      channel.topic(name, durable: true, auto_delete: false)
    end

    def exchange_name
      ENV['EXCHANGE_NAME']
    end

    def subscribers
      Hearst.subscribers
    end

  end
end
