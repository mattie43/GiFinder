require 'launchy'
require 'net/http'
require 'uri'
require 'json'
require 'pry'
require 'dotenv'
Dotenv.load('.env')

# this isn't even useful anymore lol
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
    #probably need to store the access token somewhere 
end

def get_conversations
    url = "https://slack.com/api/conversations.list?token=xoxp-1309750153941-1304391363350-1311279061490-5336b92ed4a34d1952d32fff54294069&types=public_channel%2Cprivate_channel%2Cmpim%2Cim&pretty=1"
    uri = URI.parse(url)
    response = Net::HTTP::get_response(uri)
    token = JSON.parse(response.body)
    puts token
end

def get_users_name
    url = "https://slack.com/api/users.info?token=xoxp-1309750153941-1304391363350-1311279061490-5336b92ed4a34d1952d32fff54294069&user=U018YBHAPAA&pretty=1"
    uri = URI.parse(url)
    response = Net::HTTP::get_response(uri)
    token = JSON.parse(response.body)
    puts token
end

def post_something_as_user
    #sends to selected channel (note this does not select the channel for you or enter the text)

    url = "https://slack.com/api/chat.postMessage?token=xoxp-1309750153941-1304391363350-1311279061490-5336b92ed4a34d1952d32fff54294069&channel=D018QB52AKH&text=hello%20here%20is%20a%20gif&as_user=true&pretty=1"
    uri = URI.parse(url)
    request = Net::HTTP::Post.new(uri)
    request.content_type = "application/json"
    req_options = {
    use_ssl: uri.scheme == "https",
    }

    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
    http.request(request)
    end
end
binding.pry
# to post as the user all you really need to do is run it once to get the code and auth token.
# could in theory write readme instructions for doing that in the browser and get the code variable programmatically
# either way now we're authed to my account so i should be able to write methods to actually post stuff now.
# and then obviously this gets reorganized in the saving class or whatever