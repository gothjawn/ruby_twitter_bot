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
        MAXIMUM_HASHTAG_COUNT = 10
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

        def hashtags(tweet)
            tweet_hash = tweet.to_h 
            extended_tweet = tweet_hash[:extended_tweet]
            (extended_tweet && extended_tweet[:entities][:hastags])
        end

        def tweet?(tweet)
            tweet.is_a(Twitter::Tweet)
        end

        def retweet?(tweet)
            tweet.retweet?
        end

        def allowed_hastags?(tweet)
            includes_allowed_hashtags = false

            hashtags(tweet).each do |hashtag|
                if HASHTAGS_TO_WATCH.map(&:upcase).include?("##{hashtag[:text]&.upcase}")
                    includes_allowed_hashtags = true

                    break
                end
            end

            includes_allowed_hashtags
        end
        def allowed_hashtag_count?(tweet)
            hashtags(tweet)&.count <= MAXIMUM_HASHTAG_COUNT
        end

        def sensitive_tweet?(tweet)
            tweet.possibly_sensitive?
        end

        def should_retweet?(tweet)
            tweet?(tweet) && !retweet?(tweet) && allowed_hashtag_count?(tweet) && !sensitive_tweet?(tweet) && allowed_hashtags?(tweet)
        end
    end
end

