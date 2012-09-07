require 'spec_helper'
require 'active_model'
require 'shoulda-matchers'

describe Skynet::Builder::Base do

  let(:source)  { File.join Dir.pwd, 'app', '.' }
  let(:url)     { 'https://github.com/org/app' }
  let(:repo)    { 'git@github.com:org/app.git' }
  let(:options) { {url: url, branch: 'master', destination: '/var/www', type: 'static'} }
  subject       { described_class.new 'app', options }

  describe ".validations" do
    it { should validate_presence_of :app }
    it { should validate_presence_of :url }
    it { should validate_presence_of :branch }
    it { should validate_presence_of :destination }
    it { should validate_presence_of :branches }
    it { should ensure_inclusion_of(:type).in_array(%w[static jekyll]).allow_nil(false).allow_blank(false) }
    it { should_not allow_value('base').for :type }
    describe "on @branches" do
      before(:each) { subject.valid? }

      context "when passed a single branch" do
        specify { subject.errors[:branches].should be_empty }
      end
      context "when passed multiple valid branches" do
        let(:options) { {url: url, type: 'static', branches: {master: '/var/www/production', develop: '/var/www/staging'}} }
        specify { subject.errors[:branches].should be_empty }
      end
      context "when passed an invalid branch" do
        let(:options) { {url: url, type: 'static', branches: {master: '/var/www', develop: ''}} }
        it "has an error on branches" do
          subject.errors[:branches].should include('develop must have a destination')
        end
      end
    end
    describe "on @key" do
      context "when not passed a key" do
        before(:each) { subject.valid? }
        specify { subject.errors[:key].should be_empty }
      end

      context "when passed a valid key" do
        let(:options) { {key: 'keyfile'} }
        before(:each) do
          File.stub(:readable?).and_return true
          subject.valid?
        end
        specify { subject.errors[:key].should be_empty }
      end

      context "when passed an invalid key" do
        let(:options) { {key: 'missing_keyfile'} }
        before(:each) do
          File.stub(:readable?).and_return false
          subject.valid?
        end
        it "has an error on key" do
          subject.errors[:key].should include('must be present and readable')
        end
      end
    end
  end

  describe "#build" do
    before(:each) do
      subject.stub :build_repository
      subject.stub :execute
    end

    context "when valid" do
      it { expect { subject.build }.to_not raise_error }
    end
    context "when invalid" do
      let(:options) { {} }
      it { expect { subject.build }.to raise_error ArgumentError }
    end
    context "when passing a branch" do
      it { expect { subject.build 'master' }.to_not raise_error }
      it "d" do
        subject.build 'develop'
      end
    end
  end

  context "private methods" do
    before(:each) do
      subject.branch      = 'master'
      subject.destination = '/var/www'
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
      before(:each) { subject.should_receive(:`).with "rm -rf #{source}" }

      context "without key" do
        it "should call git clone" do
          subject.should_receive(:`).with "git clone #{repo} app; cd #{source}; git checkout master"
          subject.send :create_repo
        end
      end

      context "with key" do
        let(:options) { {key: 'keyfile', url: url, branch: 'master', destination: '/var/www', type: 'static'} }
        it "should call git clone" do
          subject.should_receive(:`).with "ssh-agent bash -c 'ssh-add keyfile; git clone #{repo} app'; cd #{source}; git checkout master"
          subject.send :create_repo
        end
      end
    end

    describe "#update_repo" do
      context "without key" do
        it "should call git pull" do
          subject.should_receive(:`).with "cd #{source}; git checkout master; git pull origin master"
          subject.send :update_repo
        end
      end

      context "with key" do
        let(:options) { {key: 'keyfile', url: url, branch: 'master', destination: '/var/www', type: 'static'} }
        it "should call git pull" do
          subject.should_receive(:`).with "cd #{source}; git checkout master; ssh-agent bash -c 'ssh-add keyfile; git pull origin master'"
          subject.send :update_repo
        end
      end
    end

    describe "#repo_exists?" do
      before(:each) do
        File.should_receive(:exist?).with File.join(source, '.git')
      end

      it { subject.send :repo_exists? }
    end
  end
end
