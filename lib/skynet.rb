require 'sinatra/base'
require 'yaml'
require 'skynet/builder'

module Skynet

  class Skynet < Sinatra::Base

    configure do
      set :app_file,   'skynet.rb'
      set :config,     YAML.load_file(File.join(root, 'config.yml'))[environment]
      set :repository, config[:repository]
      set :builder,    config[:builder]
    end

    post '/skynet' do
      payload = JSON.parse params[:payload]
      if settings.repository == payload['repository']['url']
        Builder.build :builder => settings.builder, :config => settings.config
        "Thanks!"
      else
        puts "Wrong repository"
        "Sorry, not configured for this repository"
      end
    end

    Builder.build(:builder => settings.builder, :config => settings.config) if settings.config[:build_on_startup]
  end

end
