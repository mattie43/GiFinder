module Twitter
	def self.tweet_gif(gif)
		client = 
			Twitter::REST::Client.new do |config|
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

		# url = URI("https://dev-udmy9c0g.us.auth0.com/api/v2/users/USER_ID")

		# http = Net::HTTP.new(url.host, url.port)
		# http.use_ssl = true
		# http.verify_mode = OpenSSL::SSL::VERIFY_NONE

		# request = Net::HTTP::Get.new(url)
		# request["authorization"] = 'Bearer #{ENV['OAUTH_BEARER]}'

		# response = http.request(request)
		# puts response.read_body
	end
end