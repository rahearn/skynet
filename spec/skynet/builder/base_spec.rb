require 'spec_helper'

describe Skynet::Builder::Base do

  let(:options) { {} }
  let(:tmpdir)  { 'tmpdir' }
  let(:lrp)     { File.join tmpdir, 'skynet' }
  subject       { described_class.new options }
  before(:each) { ENV['TMPDIR'] = tmpdir }

  describe "#tmpdir" do
    it "prefers the enviornment variable" do
      subject.send(:tmpdir).should == tmpdir
    end

    context "without TMPDIR set" do
      before(:each) { ENV['TMPDIR'] = nil }

      it "falls back on tmp dir in working directory" do
        subject.send(:tmpdir).should == File.join(Dir.pwd, 'tmp')
      end
    end
  end

  describe "#build_repository" do
    context "repo already exists" do
      before(:each) { subject.stub(:repo_exists?).and_return true }

      it "updates the repository" do
        subject.should_receive(:update_repo).with no_args
        subject.send :build_repository
      end
    end

    context "repo does not exist" do
      before(:each) { subject.stub(:repo_exists?).and_return false }

      it "creates a new repository" do
        subject.should_receive(:create_repo).with no_args
        subject.send :build_repository
      end
    end
  end

  describe "#create_repo" do
    let(:options) { {:repository => 'repo'} }
    before(:each) do
      subject.stub(:tmpdir).and_return tmpdir
      subject.should_receive(:`).with "rm -rf #{lrp}"
      subject.should_receive(:`).with "mkdir -p #{tmpdir}; cd #{tmpdir}; git clone repo skynet"
    end

    it { subject.send :create_repo }
  end

  describe "#update_repo" do
    before(:each) { subject.should_receive(:`).with "cd #{lrp}; git pull" }

    it { subject.send :update_repo }
  end

  describe "#repo_exists?" do
    let(:repo_path) { 'repo_path' }
    before(:each) do
      File.stub(:join).with(tmpdir, 'skynet').and_return 'tmpdir/skynet'
      File.stub(:join).with('tmpdir/skynet', '.git').and_return repo_path
      File.should_receive(:exist?).with repo_path
    end

    it { subject.send :repo_exists? }
  end
end
