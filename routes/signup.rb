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
    puts params
    @signup = params
    session[:futur_user] = case params['signup-type']
                             when 'google_token'
                               {url: ApiEndPoint::GOOGLE_SIGNUP, access_token: params[:access_token]}
                             when 'facebook_token'
                               {url: ApiEndPoint::FACEBOOK_SIGNUP, access_token: params[:access_token]}
                             when 'password'
                               @errors = User.check_new_account_validity(session, params[:email], params[:password], params['confirm-password'])
                               unless @errors
                                {url: ApiEndPoint::SIGNUP, email: params[:email], password: params[:password], first_name: params['first-name'], last_name: params['last-name']}
                               end
                             else
                               redirect '/signup-step1'
                           end
    puts session[:futur_user]
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
    puts session[:futur_user], user
    req = PostRequest.new(session, :login, url, user)
    response = req.send
    if response.is_a?(APIError)
      @errors = {pseudo: response.message}
      haml :signup_step2
    end
    redirect '/signup-step3'
  end

  post '/signup-step3' do
    redirect '/'
  end
end