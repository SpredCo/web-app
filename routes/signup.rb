class Spred < Sinatra::Application
  get '/signup' do
    @title = 'signup'
    haml :signup
  end

  post '/signup' do
    endpoint = '/v1/users'
    verified_params = params.select {|k,_| [:email, :password, :first_name, :last_name].include?(k.to_sym) }
    req = Request.new(:login, endpoint, verified_params)
    req.send
    puts req.response.body
  end
end