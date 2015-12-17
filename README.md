# Hearst

[![Circle CI](https://circleci.com/gh/PackageZen/hearst.svg?style=svg)](https://circleci.com/gh/PackageZen/hearst)

Hearst is a Ruby library meant to aide in the publishing and subscribing to events from RabbitMQ in a declarative way. It provides an easy way to connect and listen to a RabbitMQ host, easy and automatic ways to publish events, and an opinionated take on subscribing and processing events.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'hearst'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install hearst

## Requirements

Hearst supports Ruby 2.0+

## Usage

Using Hearst is pretty easy. It requires two environment variables, `AMQP_HOST` and `EXCHANGE_NAME`

```sh
# Where your RabbitMQ server lives
AMQP_HOST=amqp://username:password@yourhost.com

# The exchange you want to publish events to
EXCHANGE_NAME=your_app_exchange
```

### Publishing

Hearst provides an easy interface for publishing your events to the configured exchange.

```ruby
event_key = 'users.create'
event_payload = {
  id: 1,
  email: 'john.smith@company.com',
  given_name: 'John',
  family_name: 'Smith'
}
Hearst.publish(event_key, event_payload)
```

In this case, `event_key` is a string that represents the routing key that will be published, and `event_payload` is any object that responds to `#to_json`, as Hearst will always publish JSON as the payload type.

#### ActiveRecord callbacks

Hearst wants to make publishing as easy as possible, so we've provided a module you can include in your ActiveRecord classes to automatically publish create and update events.

```ruby
class User < ActiveRecord::Base
  include Hearst::ActiveRecordCallbacks
end
```

Now Hearst will automatically publish `user.create` and `user.update` events with the models `#to_json` method. If you would like to restrict the attributes published, just define an `#amqp_properties` method and return a hash of the data you would like to publish.

### Subscribing

Providing an intuitive, flexible, declarative means of subscribing to RabbitMQ events is where Hearst was first conceived. All you need to do is create a plain-old Ruby class, include `Hearst::Subscriber` and declare the event and optionally the exchange you'd listen to, and define a `.process()` method for doing the actual work when an event is heard.

```ruby
# in app/subscribers/local_user_created_subscriber.rb
class LocalUserCreatedSubscriber
  include Hearst::Subscriber

  subscribes_to 'user.create'

  def self.process(payload)
    # do something with payload
  end
end
```

This class will automatically register and bind itself to the same `EXCHANGE_NAME` that this app publishes to. If you wanted to listen to another exchange, say for a related service, you can optionally define the `exchange: 'another_exchange'` within the `subscribes_to` declaration.

```ruby
# in app/subscribers/remote_user_created_subscriber.rb
class RemoteUserCreatedSubscriber
  include Hearst::Subscriber

  subscribes_to 'user.created', exchange: 'another_exchange'

  def self.process(payload)
    # do something with payload
  end
end
```

#### Listening

Hearst provides a Rake task that sets up a durable queue and registers the subscribers and binds them to the queue. It also handles pushing the payloads to those classes to do work on the payload, and acknowledges the message.

```sh
$ bundle exec rake hearst:listen
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/hearst/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Credits

- Inspiration for ActiveRecord callbacks from [bellycard/napa_rabbit_publisher](https://github.com/bellycard/napa_rabbit_publisher)
