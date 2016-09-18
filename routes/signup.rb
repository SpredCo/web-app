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
    puts @errors
    if @errors
      haml :signup_step1, layout: :sign_layout
    else
      redirect '/signup-step2'
    end
  end

  post '/signup-step2' do
    session[:futur_user].merge!(params[:pseudo])
    redirect '/signup-step3'
  end

  post '/signup-step3' do
    user = session[:futur_user] #.merge(params[:interesting_subject_ids])
    req = PostRequest.new(session, :login, session[:futur_user][:url], user.tap { |u| u.delete(:url) })
    response = req.send
    if response.is_a?(APIError)
      flash[:error] = response.message
      redirect '/signup'
    end
    flash[:success] = 'Successfully signed up'
    redirect '/'
  end
end