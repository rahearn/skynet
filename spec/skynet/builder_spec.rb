require 'spec_helper'

describe Skynet::Builder do

  describe ".build" do
    let(:builder)    { mock('builder').as_null_object }
    let(:mock_class) { mock('builder class').as_null_object }
    let(:args)       { {:builder => :builder, :config => :config} }

    it "initializes a new builder class" do
      described_class.should_receive(:const_get).with(:builder).and_return mock_class
      mock_class.should_receive(:new).with(:config).and_return builder

      described_class.build args
    end

    it "calls build on the new builder" do
      described_class.stub(:const_get).and_return mock_class
      mock_class.stub(:new).and_return builder
      builder.should_receive(:build).with no_args

      described_class.build args
    end
  end
end
