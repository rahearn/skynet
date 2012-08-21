require 'spec_helper'

describe Skynet::Builder::Static do

  let(:app)     { 'app' }
  let(:branch)  { 'master' }
  let(:dest)    { '/var/www/app' }
  let(:options) { {'branch' => branch, 'destination' => dest} }
  let(:source)  { File.join Dir.pwd, app, branch }
  subject       { described_class.new app, options }

  describe "#build" do
    before(:each) do
      subject.should_receive :build_repository
    end

    it "copies files to the destination" do
      FileUtils.should_receive(:cp_r).with(source, dest)
      subject.build
    end
  end
end
