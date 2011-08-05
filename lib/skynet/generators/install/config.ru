require 'bundler/setup'
Bundler.require :default

require 'skynet'
use Skynet::Skynet

require './<%= @appfile %>'
run <%= appname %>
