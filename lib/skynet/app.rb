require 'sinatra/base'
require 'yaml'
require 'json'

module Skynet

  class App < Sinatra::Base

    configure do
      set :root, Dir.pwd
      set :config, YAML.load_file(File.join(root, 'config.yml'))
    end

    get '/' do
      %[Hello. Check <a href="https://github.com/coshx/skynet">github</a> for more infomation on skynet]
    end

    post '/deploy' do
      payload = JSON.parse params[:payload]
      puts "RCA got payload: #{payload.inspect}"
      settings.config['my_app'].url
      "Thanks"
    end

  end

end
