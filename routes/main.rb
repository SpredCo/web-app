class Spred
  get '/' do
    @title = 'Spred'
    haml :index
  end
end