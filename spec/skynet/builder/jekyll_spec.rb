require 'spec_helper'

describe Skynet::Builder::Jekyll do

  let(:app)     { 'app' }
  let(:dest)    { '/var/www/app' }
  let(:options) { {destination: dest} }
  let(:source)  { File.join Dir.pwd, app }
  subject       { described_class.new app, options }

  describe "#build" do
    before(:each) do
      subject.should_receive :build_repository
      subject.stub(:valid?).and_return true
    end

    it "runs jekyll with the source and destination" do
      subject.should_receive(:`).with "jekyll #{source} #{dest}"
      subject.build
    end
  end
end
