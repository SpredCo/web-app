class Spred
  # Multiple step sign up
  get '/signup-step1' do
    haml :'signup/signup_step1', layout: :'layout/sign_layout'
  end

  get '/signup-step2' do
    @title = 'Get pseudo'
    redirect '/signup-step1' unless session[:future_user]
    haml :'signup/signup_step2', layout: :'layout/sign_layout'
  end

  get '/signup-step3' do
    @title = 'Register subject you like'
    req = GetTagsRequest.new
    req.send
    response = req.parse_response
    @tags = response.body.map {|tag| Tag.from_hash(tag)}
    haml :'signup/signup_step3', layout: :'layout/sign_layout'
  end

  post '/signup-step1' do
    @signup = params
    response = AuthenticationHelper.signup_step1(params)
    if response[:errors]
      @errors = response[:errors]
      haml :'signup/signup_step1', layout: :'layout/sign_layout'
    else
      session[:future_user] = response
      redirect '/signup-step2'
    end
  end

  post '/signup-step2' do
    user = session[:future_user]
    user[:pseudo] = @pseudo = params[:pseudo]
    response = AuthenticationHelper.signup_step2(user)
    if response.is_a?(APIError)
      @errors = {pseudo: response.message}
      haml :'signup/signup_step2', layout: :'layout/sign_layout'
    else
      user[:username] = user.delete(:email)
      response = AuthenticationHelper.login(user)
      set_user_and_tokens(response.body['access_token'], response.body['refresh_token']) unless response.is_a? APIError
      redirect '/signup-step3'
    end
  end

  post '/signup-step3' do
    if params['tags']
      params['tags'].each do |tag|
        session[:current_user].add_tag(session[:spred_tokens], tag.to_s)
      end
    end
  end
end
