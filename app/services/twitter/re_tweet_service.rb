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

            while true 
                puts 'Starting to Retweet 3, 2, 1...NOW!'
            end
        end

        private
        HASHTAGS_TO_WATCH = %W[#rails #ruby #RubyOnRails]

        def twitter_api_config
        {
            consumer_key: ENV['CONSUMER_KEY'],
            consumer_secret: ENV['CONSUMER_SECRET'],
            access_token: ENV['ACCESS_TOKEN'],
            access_token_secret: ENV['ACCESS_TOKEN_SECRET']
        }
        end

        def configure_rest_client
            puts 'Configuring Rest Client'

            Twitter::REST::Client.new(config)
        end

        def configure_stream_client
            puts 'Configuring Stream Client'

            Twitter::Streaming::Client.new(config)
        end
    end
end

