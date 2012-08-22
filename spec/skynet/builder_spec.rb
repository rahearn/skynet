require 'spec_helper'

describe Skynet::Builder do

  let(:builder)    { mock('builder').as_null_object }
  let(:mock_class) { mock('builder class').as_null_object }
  let(:config)     { {type: 'static'} }
  let(:args)       { [:app, config] }

  describe ".for_app" do
    it "initializes a new builder class" do
      described_class.should_receive(:const_get).with('Static').and_return mock_class
      mock_class.should_receive(:new).with(:app, config).and_return builder

      described_class.for_app *args
    end
  end

  describe ".build" do
    it "calls build on the new builder" do
      described_class.stub(:for_app).and_return builder
      builder.should_receive(:build).with no_args

      described_class.build *args
    end
  end
end
