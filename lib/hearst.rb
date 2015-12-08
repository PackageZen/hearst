require "bunny"
require "json"

require "hearst/version"
require "hearst/dispatcher"
require "hearst/active_record_callbacks" if defined?(ActiveSupport)

module Hearst
  def self.publish(routing_key, data)
    amqp = Hearst::Dispatcher.instance
    amqp.exchange.publish(
      data.to_json,
      routing_key: routing_key,
      content_type: "application/json"
    )
  end
end
