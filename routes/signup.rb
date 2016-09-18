class Spred < Sinatra::Application
  # Multiple step sign up
  get '/signup-step1' do
    haml :signup_step1, layout: :sign_layout
  end

  get '/signup-step2' do
    @title = 'Get pseudo'
    haml :signup_step2
  end

  get '/signup-step3' do
    @title = 'Register subject you like'
    haml :signup_step3
  end

  post '/signup-step1' do
    @signup = params
    session[:futur_user] = case params['signup-type']
                             when 'google_token'
                               {url: ApiEndPoint::GOOGLE_SIGNUP, access_token: params[:token]}
                             when 'facebook_token'
                               {url: ApiEndPoint::FACEBOOK_SIGNUP, access_token: params[:token]}
                             when 'password'
                               @errors = User.check_new_account_validity(session, params[:email], params[:password], params['confirm-password'])
                               unless @errors
                                session[:futur_user] = {url: ApiEndPoint::SIGNUP}
                                params.select { |k, _| [:email, :password, :first_name, :last_name].include?(k.to_sym) }
                               end
                             else
                               redirect '/signup-step1'
                           end
    if @errors
      haml :signup_step1, layout: :sign_layout
    else
      redirect '/signup-step2'
    end
  end

  post '/signup-step2' do
    url = session[:futur_user][:url]
    session[:futur_user].delete(:url)
    user = session[:futur_user]
    user[:pseudo] = @pseudo = params[:pseudo]
    req = PostRequest.new(session, :login, url, user)
    response = req.send
    if response.is_a?(APIError)
      @errors[:pseudo] = response.message
      haml :signup_step2
    end
    redirect '/signup-step3'
  end

  post '/signup-step3' do
    redirect '/'
  end
end