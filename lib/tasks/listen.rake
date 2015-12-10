require 'eventmachine'

namespace :hearst do

  desc 'Create a queue and listen for messages'
  task listen: :environment do
    EventMachine.run {
      Signal.trap('INT') do
        EM::stop()
      end

      Signal.trap('TERM') do
        EM::stop()
      end

      listener = Hearst::Listener.new
      listener.listen
    }
  end
end
