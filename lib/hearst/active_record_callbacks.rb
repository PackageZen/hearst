module Hearst
  module ActiveRecordCallbacks

    def self.included(base)
      base.after_commit :post_create, on: :create
      base.after_commit :post_update, on: :update
    end

    def post_create
      publish("create")
    end

    def post_update
      publish("update")
    end

    def publish(event)
      data = respond_to?(:amqp_properties) ? amqp_properties : self
      routing_key = "#{self.class.name.underscore}.#{event}"
      Hearst.publish(routing_key, data)
    end
  end
end
