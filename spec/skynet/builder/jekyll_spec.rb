require 'spec_helper'

describe Skynet::Builder::Jekyll do

  let(:app)     { 'app' }
  let(:dest)    { '/var/www/app' }
  let(:options) { {destination: dest} }
  let(:source)  { File.join Dir.pwd, app, '.' }
  subject do
    described_class.new(app, options).tap do |b|
      b.destination = dest
    end
  end

  describe "#execute" do
    it "runs jekyll with the source and destination" do
      subject.should_receive(:`).with "jekyll #{source} #{dest}"
      subject.execute
    end
  end
end
