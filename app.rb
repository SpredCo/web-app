require 'sinatra'
require 'json'
require 'haml'

class Spred < Sinatra::Application
  enable :sessions

  configure do
    set :api_url, 'http://api.sharemyscreen.fr:3000'
    set :login_url, 'http://login.sharemyscreen.fr:3000'
    set :client_key, 'r5cfOscd6CZAZ8XQ'
    set :client_secret, 'G2jkNVDUqFcPCI4e6nia3w6UOMCaryPX'
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
require_relative 'helpers/init'