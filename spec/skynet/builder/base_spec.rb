require 'spec_helper'

describe Skynet::Builder::Base do

  let(:options) { {'branch' => 'master'} }
  let(:base)    { File.join Dir.pwd, 'app' }
  let(:source)  { File.join base, 'master' }
  subject       { described_class.new 'app', options }

  describe "#build" do
    it { expect { subject.build }.to raise_error NotImplementedError }
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
    let(:options) { {'branch' => 'master', 'url' => 'repo'} }
    before(:each) do
      subject.should_receive(:`).with "rm -rf #{source}"
      subject.should_receive(:`).with "mkdir -p #{base}; cd #{base}; git clone repo master"
    end

    it { subject.send :create_repo }
  end

  describe "#update_repo" do
    before(:each) { subject.should_receive(:`).with "cd #{source}; git pull" }

    it { subject.send :update_repo }
  end

  describe "#repo_exists?" do
    before(:each) do
      File.should_receive(:exist?).with File.join(source, '.git')
    end

    it { subject.send :repo_exists? }
  end
end
