require 'sinatra/base'
require 'json'
require 'active_support/core_ext/object/blank'

module Skynet

  class App < Sinatra::Base

    before do
      @payload = JSON.parse params[:payload] unless params[:payload].nil?
    end

    get '/' do
      %[Hello. Check <a href="https://github.com/coshx/skynet">github</a> for more infomation on skynet]
    end

    post '/' do
      Skynet.logger.debug "post root params: #{params.inspect}"
      app_name = settings.config.each { |n, c| break n if c[:url] == @payload['repository']['url'] }
      if app_name.is_a? String
        deploy app_name
      else
        Skynet.logger.warn "Could not find application to deploy"
        "42"
      end
    end

    post '/:app_name' do |app_name|
      Skynet.logger.debug "post /#{app_name} params: #{params.inspect}"
      deploy app_name
    end

    private

    def deploy(app_name)
      Skynet.logger.info %{Attempting to deploy "#{app_name.class.name}"}
      config = settings.config[app_name]
      if deployable? config
        Builder.build app_name, config, branch
      else
        Skynet.logger.warn "#{app_name} is not deployable"
      end
      "42"
    end

    def deployable?(config)
      config.present? &&
        config[:url] == @payload['repository']['url'] &&
        @payload['after'] !~ /^0{40}$/
    end

    def branch
      @payload['ref'] =~ %r[^refs/heads/(.*)$]
      $1
    end
  end

end
