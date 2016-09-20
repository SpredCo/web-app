class Spred < Sinatra::Application
  # Multiple step sign up
  get '/signup-step1' do
    haml :signup_step1, layout: :sign_layout
  end

  get '/signup-step2' do
    @title = 'Get pseudo'
    redirect '/signup-step1' unless session[:futur_user]
    haml :signup_step2, layout: :sign_layout
  end

  get '/signup-step3' do
    @title = 'Register subject you like'
    haml :signup_step3, layout: :sign_layout
  end

  post '/signup-step1' do
    @signup = params
    params.each do |k, v|
      if v.empty?
        @errors ||= {}
        @errors[k] = "Le champs #{k} ne peut être vide."
      end
    end
    session[:future_user] = fill_future_user(params) unless @errors
    if @errors
      haml :signup_step1, layout: :sign_layout
    else
      redirect '/signup-step2'
    end
  end

  post '/signup-step2' do
    if params[:pseudo].empty?
      @errors = {pseudo: 'Le champs pseudo ne peut pas être vide'}
      haml :signup_step2
    end
    url = session[:future_user].delete(:url)
    signup_type = session[:future_user].delete(:signup_type)
    user = session[:future_user]
    user[:pseudo] = @pseudo = params[:pseudo]
    req = PostRequest.new(session, :login, url, user)
    response = req.send
    if response.is_a?(APIError)
      @errors = {pseudo: response.message}
      haml :signup_step2
    end
    response = User.login(session, signup_type, user)
    keep_user_in_session(response.body['access_token'], response.body['refresh_token'])
    redirect '/signup-step3'
  end

  post '/signup-step3' do
    redirect '/'
  end

  private

  def fill_future_user(params)
    p params
    case params['signup-type']
      when 'google_token'
        {url: ApiEndPoint::GOOGLE_SIGNUP, access_token: params[:access_token], signup_type: params['signup-type']}
      when 'facebook_token'
        {url: ApiEndPoint::FACEBOOK_SIGNUP, access_token: params[:access_token], signup_type: params['signup-type']}
      when 'password'
        @errors = User.check_new_account_validity(session, params[:email], params[:password], params['confirm-password'])
        p @errors
        unless @errors
          {url: ApiEndPoint::SIGNUP, email: params[:email], password: params[:password],
           first_name: params['first-name'], last_name: params['last-name'],
           signup_type: params['signup-type']}
        end
      else
        redirect '/signup-step1'
    end
  end
end