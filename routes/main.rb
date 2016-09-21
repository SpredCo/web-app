class Spred < Sinatra::Application
  get '/' do
    @title = 'Spred'
    haml :index
  end
end