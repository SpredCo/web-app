require 'sinatra'
require 'json'
require 'haml'
require 'better_errors'

class Spred < Sinatra::Application
  enable :sessions

  set :static, true
  set :root, File.dirname(__FILE__)
  set :public_folder, 'public'

  configure do
    set :client_key, 'r5cfOscd6CZAZ8XQ'
    set :client_secret, 'G2jkNVDUqFcPCI4e6nia3w6UOMCaryPX'
  end

  configure :production do
    set :haml, { :ugly=>true }
    set :clean_trace, true
  end

  configure :development do
    use BetterErrors::Middleware
    BetterErrors.application_root = __dir__
  end
end

require_relative 'models/init'
require_relative 'helpers/init'
require_relative 'routes/init'