require 'sinatra'
require 'json'
require 'base64'
require 'sinatra'
require 'haml'

class Spred < Sinatra::Application
  enable :sessions

  configure do
    set :api_url, 'http://api.sharemyscreen.fr:3000'
    set :login_url, 'http://login.sharemyscreen.fr:3000'
    set :client_key, 'zqGgPbVY25xUJ8pB'
    set :client_secret, 'E7zGQvUtyxvX7VOMFsxtV9NjDNndoxce'
    set :client_hash, Proc.new { Base64.encode64("#{client_key}:#{client_secret}") }
  end

  configure :production do
    set :haml, { :ugly=>true }
    set :clean_trace, true
  end

  configure :development do
    # ...
  end
end

require_relative 'routes/init'
require_relative 'models/init'