require 'spec_helper'

describe Hearst::Subscriber do

  class TestSubscriber
    include Hearst::Subscriber
    subscribes_to 'foo.bar', exchange: 'foo-exchange'
  end

  class LocalTestSubscriber
    include Hearst::Subscriber
    subscribes_to 'local.foo.bar'
  end

  it 'auto-registers itself with Hearst' do
    expect(Hearst.subscribers).to include(TestSubscriber)
  end

  it 'stores event and exchange configuration on class' do
    expect(TestSubscriber.event).to eq('foo.bar')
    expect(TestSubscriber.exchange).to eq('foo-exchange')
  end

  it 'raises error if .process is not implemented' do
    expect {
      TestSubscriber.process(pay: 'load')
    }.to raise_error(NotImplementedError)
  end

  it 'defaults to local exchange name from ENV if not declared' do
    expect(LocalTestSubscriber.exchange).to eq(ENV['EXCHANGE_NAME'])
  end

end
