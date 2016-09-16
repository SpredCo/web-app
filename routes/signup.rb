class Spred < Sinatra::Application

  get '/signup-step1' do
    haml :signup_step1, :layout => :sign_layout
  end

  get '/signup' do
    @title = 'signup'
    haml :signup
  end

  post '/signup' do
    verified_params = params.select {|k,_| [:email, :password, :first_name, :last_name, :pseudo].include?(k.to_sym) }
    req = PostRequest.new(session, :login, ApiEndPoint::SIGNUP, verified_params)
    req.send
    puts req.response.body
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