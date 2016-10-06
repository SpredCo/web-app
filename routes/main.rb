class Spred
  get '/' do
    @title = 'Spred'
    haml :'home/index', layout: :'layout/layout'
  end
end