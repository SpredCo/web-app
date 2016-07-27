class Spred < Sinatra::Application
  get '/login' do
    @title = 'Login'
    haml :login
  end

  post '/login' do
    verified_params = {'grant_type' => 'password'}.merge(params.select {|k,_| [:username, :password].include?(k.to_sym) })
    req = PostRequest.new(session, :login, ApiEndPoint::LOGIN, verified_params)
    req.send
    keep_user_in_session(req.response.body['access_token'], req.response.body['refresh_token'])
  end

  get '/logout' do
    session[:spred_access_token] = nil
    session[:spred_refresh_token] = nil
    redirect '/'
  end

  private

  def keep_user_in_session(access_token, refresh_token)
    session[:current_user] = {access_token: access_token, refresh_token: refresh_token}
    req = GetRequest.new(session, :api, ApiEndPoint::GET_USER + '/me')
    req.send
    session[:current_user].merge!(req.response.body.select! {|k,_| [:email, :first_name, :last_name].include?(k.to_sym)})
  end
end