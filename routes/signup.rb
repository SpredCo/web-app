class Spred
  # Multiple step sign up
  get '/signup-step1' do
    haml :signup_step1, layout: :sign_layout
  end

  get '/signup-step2' do
    @title = 'Get pseudo'
    redirect '/signup-step1' unless session[:future_user]
    haml :signup_step2, layout: :sign_layout
  end

  get '/signup-step3' do
    @title = 'Register subject you like'
    haml :signup_step3, layout: :sign_layout
  end

  post '/signup-step1' do
    @signup = params
    response = AuthenticationHelper.signup_step1(params)
    response[:errors] ? @errors = response[:errors] : session[:future_user] = response
    p session[:future_user]
    if @errors
      haml :signup_step1, layout: :sign_layout
    else
      redirect '/signup-step2'
    end
  end

  post '/signup-step2' do
    request = session[:future_user].delete(:request)
    session[:future_user].delete(:signup_type)
    user = session[:future_user]
    user[:pseudo] = @pseudo = params[:pseudo]
    response = AuthenticationHelper.signup_step2(request, user)
    if response.is_a?(APIError)
      @errors = {pseudo: response.message}
      haml :signup_step2, layout: :sign_layout
    else
      user[:username] = user.delete(:email)
      response = AuthenticationHelper.login(user)
      set_user_and_tokens(response.body['access_token'], response.body['refresh_token']) unless response.is_a? APIError
      redirect '/signup-step3'
    end
  end

  post '/signup-step3' do
    redirect '/'
  end
end