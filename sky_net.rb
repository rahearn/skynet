require 'sinatra/base'
require 'json'
require 'yaml'

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

  get '/' do
    "config: #{settings.config.inspect}"
  end

  post '/skynet' do
    payload = JSON.parse params[:payload]
    if settings.repository == payload['repository']['url']
      # builder = "SkyNet::Builder::#{settings.builder}".constantize.new(config)
      # builder.run
      "Thanks!"
    else
      puts "Wrong repository"
      "Sorry, not configured for this repository"
    end
  end

  run! if app_file == $0
end
