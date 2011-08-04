require 'sinatra/base'
require 'yaml'
$:.unshift File.dirname __FILE__
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
      Builder.const_get(settings.builder).new(settings.config).run
      "Thanks!"
    else
      puts "Wrong repository"
      "Sorry, not configured for this repository"
    end
  end

end
