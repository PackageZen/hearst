module Hearst
  module Logging
    def self.initialize_logger(log_target = STDOUT)
      previous_logger = defined?(@logger) ? @logger : nil
      @logger = Logger.new(log_target)
      @logger.level = Logger::INFO
      previous_logger.close if previous_logger
      @logger
    end

    def self.logger
      defined?(@logger) ? @logger : initialize_logger
    end

    def self.logger=(log)
      @logger = (log ? log : Logger.new('/dev/null'))
    end
  end
end
