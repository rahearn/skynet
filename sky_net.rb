require 'sinatra/base'
require 'yaml'
require 'builder'

class SkyNet < Sinatra::Base

  configure do
    set :app_file,   'sky_net.rb'
    set :config,     YAML.load_file(File.join(root, 'config.yml'))[environment]
    set :repository, config[:repository]
    set :builder,    config[:builder]
  end

  configure :production do
    enable :logging
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
