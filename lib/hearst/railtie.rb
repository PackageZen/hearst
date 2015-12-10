module Hearst
  class Railtie < Rails::Railtie
    railtie_name :hearst

    rake_tasks do
      load "tasks/listen.rake"
    end
  end
end
