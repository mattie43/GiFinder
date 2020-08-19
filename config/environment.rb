require 'bundler/setup'
Bundler.require

ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: "db/development.sqlite3"
)

ActiveRecord::Base.logger = Logger.new(STDOUT)

require_all 'app'

require 'open-uri'
require 'json'
require 'rest-client'
require 'net/http'
require 'awesome_print'
require 'uri'
require 'openssl'
# require 'tco'
# require 'rmagick'
require 'catpix'
require 'mini_magick'
require 'bcrypt'
# require 'image_optimizer'
require 'tty-prompt'
