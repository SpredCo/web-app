class Spred < Sinatra::Application
  # Multiple step sign up
  get '/signup-step1' do
    haml :signup_step1, :layout => :sign_layout
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
    session[:futur_user] = case params[:signup_type]
                        when 'google_token'
                          {url: ApiEndPoint::GOOGLE_SIGNUP, access_token: params[:token]}
                        when 'facebook_token'
                          {url: ApiEndPoint::FACEBOOK_SIGNUP, access_token: params[:token]}
                        when 'password'
                          session[:futur_user] = {url: ApiEndPoint::SIGNUP}
                          if params[:password] != params['confirm-password']
                            flash[:error] = 'Password does not match'
                            redirect '/signup-step1'
                          end
                          params.select {|k,_| [:email, :password, :first_name, :last_name].include?(k.to_sym) }
                        else
                          flash[:error] = 'Invalid signup type'
                          redirect '/signup-step1'
                      end
    redirect '/signup-step2'
  end

  post '/signup-step2' do
    session[:futur_user].merge!(params[:pseudo])
    redirect '/signup-step3'
  end

  post '/signup-step3' do
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
end