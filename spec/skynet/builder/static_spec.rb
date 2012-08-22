require 'spec_helper'

describe Skynet::Builder::Static do

  let(:app)     { 'app' }
  let(:dest)    { '/var/www/app' }
  let(:options) { {destination: dest} }
  let(:source)  { File.join Dir.pwd, app, '.' }
  subject       { described_class.new app, options }

  describe "#build" do
    before(:each) do
      subject.should_receive :build_repository
      subject.stub(:valid?).and_return true
      Dir.stub(:glob).and_return [:one, :two]
    end

    it "removes destination files first" do
      FileUtils.stub :remove_entry_secure
      FileUtils.stub :cp_r
      FileUtils.should_receive(:rm_rf).with [:one, :two], secure: true
      subject.build
    end

    it "copies files to the destination" do
      FileUtils.stub :rm_rf
      FileUtils.stub :remove_entry_secure
      FileUtils.should_receive(:cp_r).with(source, dest)
      subject.build
    end

    it "removes .git from the destination" do
      FileUtils.stub :rm_rf
      FileUtils.stub :cp_r
      FileUtils.should_receive(:remove_entry_secure).with "#{dest}/.git"
      subject.build
    end
  end
end
