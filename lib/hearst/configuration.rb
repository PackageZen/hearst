module Hearst
  class Configuration
    attr_accessor :subscriber_paths

    def initialize
      @subscriber_paths = ["app/subscribers"]
    end
  end
end
