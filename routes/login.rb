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
    haml :main, :locals => {response: req.response.body}
  end

  post '/google_login' do
    req = PostRequest.new(session, :login, ApiEndPoint::GOOGLE_LOGIN, {access_token: params[:access_token]})
    req.send
    puts req.response.body
    keep_user_in_session(req.response.body['access_token'], req.response.body['refresh_token'])
    haml :main, :locals => {response: req.response.body}
  end

  post '/facebook_login' do
    req = PostRequest.new(session, :login, ApiEndPoint::FACEBOOK_LOGIN, {access_token: params[:access_token]})
    req.send
    puts req.response.body
    keep_user_in_session(req.response.body['access_token'], req.response.body['refresh_token'])
    haml :main, :locals => {response: req.response.body}
  end


  get '/logout' do
    session[:current_user][:access_token] = nil
    session[:current_user][:refresh_token] = nil
    redirect '/'
  end

  private

  def keep_user_in_session(access_token, refresh_token)
    session[:current_user] ||= {}
    session[:current_user].merge!({access_token: access_token, refresh_token: refresh_token})
    req = GetRequest.new(session, :api, ApiEndPoint::USER + '/me')
    req.send
    session[:current_user].merge!(req.response.body.select! {|k,_| [:email, :first_name, :last_name, :id, :following].include?(k.to_sym)})
  end
end