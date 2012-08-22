require 'sinatra/base'
require 'json'

module Skynet

  class App < Sinatra::Base

    get '/' do
      %[Hello. Check <a href="https://github.com/coshx/skynet">github</a> for more infomation on skynet]
    end

    post '/:app_name' do |app_name|
      Skynet.logger.debug "params: #{params.inspect}"
      payload = JSON.parse params[:payload]
      config  = settings.config[app_name]
      if deployable? config, payload
        Builder.build app_name, config
      else
        Skynet.logger.warn "#{app_name} is not deployable"
      end
      "42"
    end

    private

    def deployable?(config, payload)
      !config.nil? &&
        config[:url] == payload['repository']['url'] &&
        payload['ref'] == "refs/heads/#{config[:branch]}"
    end
  end

end
