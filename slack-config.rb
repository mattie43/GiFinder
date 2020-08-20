require 'launchy'
require 'net/http'
require 'uri'
require 'json'
require 'pry'
require 'dotenv'
Dotenv.load('.env')


def post_to_gifinder_channel
    url = "#{ENV['GIFINDER_CHANNEL_WEBHOOK']}"
   
    uri = URI.parse(url)
    request = Net::HTTP::Post.new(uri)
    request.content_type = "application/json"
    request.body = JSON.dump({
    "text" => "now i have all the permissions"
    })

    req_options = {
    use_ssl: uri.scheme == "https",
    }

    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
    http.request(request)
    end
end

def launch_url_for_code
    Launchy.open("https://slack.com/oauth/v2/authorize?client_id=#{ENV['SLACK_CLIENT_ID']}&user_scope=chat%3Awrite")
end

def convert_code_to_access_token
    url = "https://slack.com/api/oauth.v2.access?code=#{ENV['SLACK_CODE']}&client_id=#{ENV['SLACK_CLIENT_ID']}&client_secret=#{ENV['SLACK_CLIENT_SECRET']}"
    uri = URI.parse(url)
    response = Net::HTTP.get_response(uri)
    token = JSON.parse(response.body)
    token = token["authed_user"]["access_token"]
end

# to post as the user all you really need to do is run it once to get the code and auth token.
# could in theory write readme instructions for doing that in the browser and get the code variable programmatically
# either way now we're authed to my account so i should be able to write methods to actually post stuff now.
# and then obviously this gets reorganized in the saving class or whatever