require 'spec_helper'
require 'active_model'
require 'shoulda-matchers'

describe Skynet::Builder::Base do

  let(:source)  { File.join Dir.pwd, 'app', '.' }
  let(:repo)    { 'git@github.com:app.git' }
  let(:options) { {url: repo, branch: 'master', destination: '/var/www', type: 'static'} }
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
        let(:options) { {url: repo, type: 'static', branches: {master: '/var/www/production', develop: '/var/www/staging'}} }
        specify { subject.errors[:branches].should be_empty }
      end
      context "when passed an invalid branch" do
        let(:options) { {url: repo, type: 'static', branches: {master: '/var/www', develop: ''}} }
        it "has an error on branches" do
          subject.errors[:branches].should include('develop must have a destination')
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
      before(:each) do
        subject.should_receive(:`).with "rm -rf #{source}"
        subject.should_receive(:`).with "git clone #{repo} app; cd #{source}; git checkout master"
      end

      it { subject.send :create_repo }
    end

    describe "#update_repo" do
      before(:each) { subject.should_receive(:`).with "cd #{source}; git checkout master; git pull origin master" }

      it { subject.send :update_repo }
    end

    describe "#repo_exists?" do
      before(:each) do
        File.should_receive(:exist?).with File.join(source, '.git')
      end

      it { subject.send :repo_exists? }
    end
  end
end
