require 'json'
require 'active_support/core_ext/string/strip'

class HookGenerator

  attr_reader :config, :server, :output

  def initialize(config, server, output)
    @config = config
    @server = server
    @output = output
  end

  def generate
    File.open(output, 'w') do |file|
      payload = {
          repository: { url: config[:url] },
          before: '$oldrev',
          after: '$newrev',
          ref: '$refname'
      }
      file.write <<-EOS.strip_heredoc
        read oldrev newrev refname

        curl -d "payload=#{payload.to_json.gsub('"', '\"')}" #{server}
      EOS
    end
  end
end