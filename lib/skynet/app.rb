require 'sinatra/base'
require 'json'

module Skynet

  class App < Sinatra::Base

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
