module Hearst
  module Subscriber

    def self.included(base)
      base.extend(ClassMethods)
      base.class_attribute :event
      base.class_attribute :exchange

      Hearst.register!(base)
    end

    module ClassMethods
      def subscribes_to(event, exchange: nil)
        self.event = event
        self.exchange = exchange || ENV['EXCHANGE_NAME']
      end

      def process(payload)
        raise NotImplementedError
      end
    end
  end
end
