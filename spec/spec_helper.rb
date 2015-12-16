$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'hearst'
require 'active_record'

# required for amqp configuration
ENV['EXCHANGE_NAME'] = 'test'

RSpec.configure do |config|

  ActiveRecord::Base.raise_in_transactional_callbacks = true
  ActiveRecord::Schema.verbose = false

  config.before(:suite) do
    ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: ':memory:')

    ActiveRecord::Schema.define(version: 1) do
      create_table :test_models do |t|
        t.string :variable
      end
    end

    class TestModel < ActiveRecord::Base
    end
  end
end
