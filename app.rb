require 'sinatra'
require 'json'
require 'haml'
require 'better_errors' if ENV['RACK_ENV'] === 'development'
require 'sinatra/reloader' if ENV['RACK_ENV'] === 'development'
require 'algoliasearch'

class Spred < Sinatra::Application
  use Rack::Session::Pool

  set :static, true
  set :root, File.dirname(__FILE__)
  set :public_folder, 'public'

  Algolia.init(application_id: ENV['ALGOLIA_APP_ID'] || 'KGZYQKI2SD', api_key: ENV['ALGOLIA_READ_KEY'] ||'a8583e100dbd3bb6e5a64d76462d1f5b')

  configure do
    set :client_key, ENV['WEB_CLIENT_ID'] || 'ob35JV0MlrSKlIw8'
    set :client_secret, ENV['WEB_CLIENT_SECRET'] || 'IA5gjpiC6FkorT7ZNDVRZHumtvrTXC8l'
    #set :haml, layout: :'layout/layout'
  end

  configure :production do
    set :haml, ugly: true
    set :clean_trace, true
  end

  configure :development do
    use BetterErrors::Middleware
    BetterErrors.application_root = __dir__
  end

  not_found do
    status 404
    haml :'error/404', layout: :'layout/layout'
  end
end

require_relative 'models/init'
require_relative 'helpers/init'
require_relative 'routes/init'
