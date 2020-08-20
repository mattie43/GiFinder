module Text
    def self.text_gif(gif)
        url = URI("https://quick-easy-sms.p.rapidapi.com/send")

        http = Net::HTTP.new(url.host, url.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE

        request = Net::HTTP::Post.new(url)
        request["x-rapidapi-host"] = 'quick-easy-sms.p.rapidapi.com'
        request["x-rapidapi-key"] = ENV['RAPID_API_KEY']
        request["content-type"] = 'application/x-www-form-urlencoded'

        number = TTY::Prompt.new.mask("What number would you like to send this gif to?")
        message = TTY::Prompt.new.ask("What would you like to say with this gif?")
        request.body = "message=#{message}\n#{gif.link}&toNumber=1#{number}"
        print TTY::Box.success("Message sent successfully!")
        sleep(2.0)
    end
end