require "bunny"
require "eventmachine"
require "json"
require "rake"

require "hearst/version"
require "hearst/dispatcher"
require "hearst/listener"
require "hearst/logging"
require "hearst/subscriber"
require "hearst/roster"
require "hearst/active_record_callbacks"

if defined?(Rake)
  load "tasks/listen.rake"
elsif defined?(Rails)
  require "hearst/railtie"
end

module Hearst

  def self.initialize!
    @@roster = Roster.new
  end

  def self.roster
    @@roster
  end

  def self.register!(subscriber)
    roster.register!(subscriber)
  end

  def self.subscribers
    roster.subscribers
  end

  def self.publish(routing_key, data)
    amqp = Hearst::Dispatcher.instance
    amqp.exchange.publish(
      data.to_json,
      routing_key: routing_key,
      content_type: "application/json"
    )
    Hearst::Logging.logger.info "Hearst published event=#{routing_key}"
  end
end

Hearst.initialize!
