module Twitter
    def self.tweet_gif(gif)
        client = Twitter::REST::Client.new do |config|
            config.consumer_key        = ENV['TWITTER_KEY']
            config.consumer_secret     = ENV['TWITTER_SECRET']
            config.bearer_token        = ENV['TWITTER_BEARER_TOKEN']
            config.access_token        = ENV['ACCESS_TOKEN']
            config.access_token_secret = ENV['ACCESS_SECRET']
        end
        
        message = TTY::Prompt.new.ask("What would you like to say with this gif?")
        client.update("#{message}\n#{gif.link}")
        print TTY::Box.success("Tweet made successfully!")
        sleep(2.0)
    end
end