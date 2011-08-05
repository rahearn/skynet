require 'bundler/setup'
Bundler.require :default
$:.unshift File.dirname __FILE__
require 'sky_net'

run SkyNet
