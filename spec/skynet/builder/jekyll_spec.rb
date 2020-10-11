require 'spec_helper'

describe Skynet::Builder::Jekyll, type: :model do

  let(:app)     { 'app' }
  let(:dest)    { '/var/www/app' }
  let(:options) { {branches: {main: dest}} }
  let(:source)  { File.join Dir.pwd, app, '.' }
  subject do
    described_class.new(app, options).tap do |b|
      b.destination = dest
    end
  end

  describe "#execute" do
    it "runs jekyll with the source and destination" do
      expect(subject).to receive(:`).with "jekyll build --source #{source} --destination #{dest}"
      subject.execute
    end
  end
end
