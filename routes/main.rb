class Spred < Sinatra::Application
  get '/' do
    @title = 'Welcome to MyApp'
    haml :main
  end
end