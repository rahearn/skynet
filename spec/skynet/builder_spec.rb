require 'spec_helper'

describe Skynet::Builder do

  let(:builder)    { double('builder').as_null_object }
  let(:mock_class) { double('builder class').as_null_object }
  let(:config)     { {type: 'static'} }

  describe ".for_app" do
    let(:args) { [:app, config] }

    it "initializes a new builder class" do
      expect(described_class).to receive(:const_get).with('Static').and_return(mock_class)
      expect(mock_class).to receive(:new).with(:app, config).and_return(builder)

      described_class.for_app *args
    end
  end

  describe ".build" do
    let(:args) { [:app, config, :master] }

    it "calls build on the new builder" do
      allow(described_class).to receive(:for_app).and_return(builder)
      expect(builder).to receive(:build).with(:master)

      described_class.build *args
    end
  end
end
