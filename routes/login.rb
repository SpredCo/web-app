class Spred
  get '/login' do
    @title = 'Login'
    haml :'login/login', layout: :'layout/layout'
  end

  post '/login' do
    response = AuthenticationHelper.login(params)
    if response.nil? || response.is_a?(APIError)
      @errors = {default: APIError::INVALID_LOGIN}
      haml :'login/login', layout: :'layout/layout'
    else
      set_user_and_tokens(response.body['access_token'], response.body['refresh_token'])
      redirect '/'
    end
  end

  get '/logout' do
    session[:current_user] = nil
    redirect '/'
  end

  def set_error_and_redirect
    @errors = {default: response.message}
    haml :'login/login', layout: :'layout/layout'
  end

  def set_user_and_tokens(access_token, refresh_token)
    session[:spred_tokens] = TokenBox.new(access_token, refresh_token)
    session[:current_user] = get_current_user_from_token(session[:spred_tokens])
  end

  def get_current_user_from_token(tokens)
    UserHelper.get_current(tokens)
  end
end
