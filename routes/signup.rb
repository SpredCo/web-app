class Spred < Sinatra::Application
  # Multiple step sign up
  get '/signup_step1' do
    haml :signup_step1, :layout => :sign_layout
  end

  get '/signup_step2' do
    @title = 'Get pseudo'
    haml :signup_step2
  end

  get '/signup_step3' do
    @title = 'Register subject you like'
    haml :signup_step3
  end

  post '/signup_step1' do
    session[:futur_user] = {url: ApiEndPoint::SIGNUP}
    if params[:password] != params[:confirm_password]
      flash[:error] = 'Password does not match'
      redirect '/signup'
    end
    verified_params = params.select {|k,_| [:email, :password, :first_name, :last_name].include?(k.to_sym) }
    session[:futur_user] = verified_params
    redirect '/signup_step2'
  end

  post '/signup_step2' do
    session[:futur_user].merge!(params[:pseudo])
    redirect '/signup_step3'
  end

  post '/signup_step3' do
    user = session[:futur_user]#.merge(params[:interesting_subject_ids])
    req = PostRequest.new(session, :login, session[:futur_user][:url], user.tap {|u| u.delete(:url)})
    response = req.send
    if response.is_a?(APIError)
      flash[:error] = response.message
      redirect '/signup'
    end
    flash[:success] = 'Successfully signed up'
    redirect '/'
  end

  # Multiple step social network sign up
  post '/google_signup' do
    session[:futur_user] = {url: ApiEndPoint::GOOGLE_SIGNUP}
    session[:futur_user][:access_token] = params[:token]
    redirect '/signup_step2'
  end

  post '/facebook_signup' do
    session[:futur_user] = {url: ApiEndPoint::FACEBOOK_SIGNUP}
    session[:futur_user][:access_token] = params[:token]
    redirect '/signup_step2'
  end
end