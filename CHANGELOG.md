# master
- Support for RabbitMQ topic exchanges
- Support for only single queue to listen
- `Hearst.publish` for dispatching events
- `Hearst::ActiveRecordCallbacks` for auto-publishing ActiveRecord create/update events
- `Hearst::Subscriber` for declarative means of defining events and exchanges to subscribe to
- `Hearst::Listener` and `rake hearst:listen` to setup and subscribe to events
