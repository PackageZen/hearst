module Hearst
  class Roster
    attr_reader :subscribers

    def initialize
      @subscribers = []
      @mutex = Mutex.new
    end

    def register!(subscriber)
      @mutex.synchronize { @subscribers << subscriber }
    end
  end
end
