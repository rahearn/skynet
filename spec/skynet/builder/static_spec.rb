require 'spec_helper'

describe Skynet::Builder::Static do

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

    it "copies files to the destination" do
      FileUtils.should_receive(:cp_r).with(source, dest)
      subject.build
    end
  end
end
