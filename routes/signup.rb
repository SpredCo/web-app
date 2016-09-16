class Spred < Sinatra::Application

  get '/signup-step1' do
    haml :signup_step1, :layout => :sign_layout
  end

  get '/signup' do
    @title = 'signup'
    haml :signup
  end

  post '/signup' do
    if params[:password] != params[:confirm_password]
      flash[:error] = 'Password does not match'
      redirect '/signup'
    end
    verified_params = params.select {|k,_| [:email, :password, :first_name, :last_name].include?(k.to_sym) }
    session[:futur_user] = verified_params
    redirect '/signup_step2'
  end

  get '/signup_step2' do
    @title = 'Get pseudo'
    haml :signup_step2
  end

  post '/signup_step2' do
    session[:futur_user].merge!(params[:pseudo])
    redirect '/signup_step3'
  end

  get '/signup_step3' do
    @title = 'Register subject you like'
    haml :signup_step3
  end

  post '/signup_step3' do
    user = session[:futur_user]#.merge(params[:interesting_subject_ids])
    req = PostRequest.new(session, :login, ApiEndPoint::SIGNUP, user)
    response = req.send
    if response.is_a?(APIError)
      flash[:error] = response.message
      redirect '/signup'
    end
    flash[:success] = 'Successfully signed up'
    redirect '/'
  end

  post '/google_signup' do
    req = PostRequest.new(session, :login, ApiEndPoint::GOOGLE_SIGNUP, {access_token: params[:access_token], pseudo: params[:pseudo]})
    req.send
    puts req.response.body
    keep_user_in_session(req.response.body['access_token'], req.response.body['refresh_token'])
    haml :main, :locals => {response: req.response.body}
  end

  post '/facebook_signup' do
    req = PostRequest.new(session, :login, ApiEndPoint::FACEBOOK_SIGNUP, {access_token: params[:access_token], pseudo: params[:pseudo]})
    req.send
    puts req.response.body
    keep_user_in_session(req.response.body['access_token'], req.response.body['refresh_token'])
    haml :main, :locals => {response: req.response.body}
  end
end