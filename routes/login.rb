class Spred
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
    @user = get_current_user_from_token(response.body['access_token'], response.body['refresh_token'])
    session[:current_user] = @user
    haml :main
  end

  post '/google_login' do
    response = Authentication.login(params)
    set_error_and_redirect if response.is_a?(APIError)
    @user = get_current_user_from_token(response.body['access_token'], response.body['refresh_token'])
    session[:current_user] = @user
    haml :main
  end

  post '/facebook_login' do
    response = Authentication.login(params)
    set_error_and_redirect if response.is_a?(APIError)
    @user = get_current_user_from_token(response.body['access_token'], response.body['refresh_token'])
    session[:current_user] = @user
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

  def get_current_user_from_token(access_token, refresh_token)
    session[:current_user] = TokenBox.new(access_token, refresh_token)
    $session = session
    User.get_current
  end
end
