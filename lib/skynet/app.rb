require 'sinatra/base'
require 'json'
require 'active_support/core_ext/object/blank'

module Skynet

  class App < Sinatra::Base

    get '/' do
      %[Hello. Check <a href="https://github.com/coshx/skynet">github</a> for more infomation on skynet]
    end

    post '/:app_name' do |app_name|
      Skynet.logger.debug "params: #{params.inspect}"
      @payload = JSON.parse params[:payload]
      @config  = settings.config[app_name]
      if deployable?
        Builder.build app_name, @config, branch
      else
        Skynet.logger.warn "#{app_name} is not deployable"
      end
      "42"
    end

    private

    def deployable?
      @config.present? &&
        @config[:url] == @payload['repository']['url'] &&
        @payload['after'] !~ /^0{40}$/
    end

    def branch
      @payload['ref'] =~ %r[^refs/heads/(.*)$]
      $1
    end
  end

end
