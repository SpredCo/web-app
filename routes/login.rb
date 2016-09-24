class Spred < Sinatra::Application
  get '/login' do
    @title = 'Login'
    haml :login
  end

  post '/login' do
    response = Authentication.login(params)
    unless response
      @errors = {default: APIError::INVALID_LOGIN}
      haml :login
    end
    keep_user_in_session(response.body['access_token'], response.body['refresh_token'])
    haml :profile
  end

  post '/google_login' do
    response = Authentication.login(params)
    set_error_and_redirect if response.is_a?(APIError)
    keep_user_in_session(response.body['access_token'], response.body['refresh_token'])
    haml :main
  end

  post '/facebook_login' do
    response = Authentication.login(params)
    set_error_and_redirect if response.is_a?(APIError)
    keep_user_in_session(response.body['access_token'], response.body['refresh_token'])
    haml :main
  end


  get '/logout' do
    session[:current_user] = nil
    redirect '/'
  end

  def set_error_and_redirect
    @errors = {default: response.message}
    haml :login
  end

  def keep_user_in_session(access_token, refresh_token)
    session[:current_user] = {}
    session[:current_user].merge!({access_token: access_token, refresh_token: refresh_token})
    req = GetRequest.new(session, :api, ApiEndPoint::USER + '/me')
    req.send
    session[:current_user].merge!(req.response.body.select {|k,_| [:email, :first_name, :last_name, :id, :following, :picture_url].include?(k.to_sym)})
  end
end
