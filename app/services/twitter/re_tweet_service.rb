require 'rubygems'
require 'bundler/setup'
require 'twitter'
require 'figaro'

Figaro.application = Figaro::Application.new(
    environment: 'production',
    path: File.expand_path('config/application.yml')
)

Figaro.load


module Twitter
    class ReTweetService
        attr_reader :config

        def initialize 
            @config = twitter_api_config
        end

        def perform 
            rest_client = configure_rest_client
            stream_client = configure_stream_client
        end

        private
    end
end