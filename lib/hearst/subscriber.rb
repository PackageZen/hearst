module Hearst
  module Subscriber

    def self.included(base)
      base.extend(ClassMethods)
      base.class_attribute :subscribes_to
      base.class_attribute :subscribes_from

      Hearst.register!(base)
    end

    module ClassMethods
      def subscribes(to:, from:)
        self.subscribes_to = to
        self.subscribes_from = from
      end
    end
  end
end
