class Spred < Sinatra::Application
  get '/login' do
    @title = 'Login'
    haml :login
  end

  post '/login' do
    verified_params = {'grant_type' => 'password'}.merge!(params.select {|k,_| [:username, :password].include?(k.to_sym) })
    req = PostRequest.new(session, :login, ApiEndPoint::LOGIN, verified_params)
    response = req.send
    unless response
      @errors[:default] = APIError::INVALID_LOGIN
      haml :login
    end
    keep_user_in_session(response.body['access_token'], response.body['refresh_token'])
    haml :profile, :locals => {user: session[:current_user]}
  end

  post '/google_login' do
    req = PostRequest.new(session, :login, ApiEndPoint::GOOGLE_LOGIN, {access_token: params[:access_token]})
    response = req.send
    set_error_and_redirect if response.is_a?(APIError)
    keep_user_in_session(response.body['access_token'], response.body['refresh_token'])
    haml :main, :locals => {response: response.body}
  end

  post '/facebook_login' do
    req = PostRequest.new(session, :login, ApiEndPoint::FACEBOOK_LOGIN, {access_token: params[:access_token]})
    response = req.send
    set_error_and_redirect if response.is_a?(APIError)
    keep_user_in_session(response.body['access_token'], response.body['refresh_token'])
    haml :main, :locals => {response: response.body}
  end


  get '/logout' do
    session[:current_user][:access_token] = nil
    session[:current_user][:refresh_token] = nil
    session[:current_user] = nil
    redirect '/'
  end

  def set_error_and_redirect
    @errors[:default] = response.message
    haml :login
  end

  def keep_user_in_session(access_token, refresh_token)
    session[:current_user] ||= {}
    session[:current_user].merge!({access_token: access_token, refresh_token: refresh_token})
    req = GetRequest.new(session, :api, ApiEndPoint::USER + '/me')
    req.send
    session[:current_user].merge!(req.response.body.select {|k,_| [:email, :first_name, :last_name, :id, :following, :picture_url].include?(k.to_sym)})
  end
end
