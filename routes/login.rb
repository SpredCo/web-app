class Spred < Sinatra::Application
  get '/login' do
    @title = 'Login'
    haml :login
  end

  post '/login' do
    endpoint = '/v1/oauth2/token'
    verified_params = {'grant_type' => 'password'}.merge(params.select {|k,_| [:username, :password].include?(k.to_sym) })
    req = Request.new(:login, endpoint, verified_params)
    req.send
    puts req.response.body.class.name
    response.set_cookie('spred_access_token', value: req.response.body['access_token'], domain: false)
    response.set_cookie('spred_refresh_token', value: req.response.body['refresh_token'], domain: false)
  end

  get '/logout' do
    redirect '/'
  end
end