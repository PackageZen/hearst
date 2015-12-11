module Hearst
  module Subscriber

    def self.included(base)
      base.extend(ClassMethods)
      base.class_attribute :event
      base.class_attribute :exchange

      Hearst.register!(base)
    end

    module ClassMethods
      def subscribes(event:, exchange:)
        self.event = event
        self.exchange = exchange
      end

      def process(payload)
        raise NotImplementedError
      end
    end
  end
end
