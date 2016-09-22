class Spred < Sinatra::Application
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
    response = Authentication.signup_step1(params)
    response[:errors] ? @errors = response[:errors] : session[:future_user] = response
    if @errors
      haml :signup_step1, layout: :sign_layout
    else
      redirect '/signup-step2'
    end
  end

  post '/signup-step2' do
    request = session[:future_user].delete(:request)
    signup_type = session[:future_user].delete(:signup_type)
    user = session[:future_user]
    user[:pseudo] = @pseudo = params[:pseudo]
    response = Authentication.signup_step2(request, user)
    if response.is_a?(APIError)
      @errors = {pseudo: response.message}
      haml :signup_step2
    end
    r = Authentication.login(signup_type, user)
    puts r
    redirect '/signup-step3'
  end

  post '/signup-step3' do
    redirect '/'
  end
end