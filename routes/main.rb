class Spred
  get '/' do
    haml :'home/index', layout: :'layout/layout'
  end
end