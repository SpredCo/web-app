class Spred < Sinatra::Application
  get '/signup' do
    @title = 'signup'
    haml :signup
  end

  post '/signup' do
    verified_params = params.select {|k,_| [:email, :password, :first_name, :last_name].include?(k.to_sym) }
    req = PostRequest.new(session, :login, ApiEndPoint::SIGNUP, verified_params)
    req.send
    puts req.response.body
  end
end