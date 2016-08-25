class Spred < Sinatra::Application
  get '/user/show/:id' do
    req = GetRequest.new(session, :api, ApiEndPoint::USER + "/#{params[:id]}")
    req.send
    user = req.response.body.reject { |k,_| User::PRIVATE_FIELDS.include?(k) }
    haml :user_show, :locals => {user: user, response: req.response.body}
  end

  get '/user/edit/:id' do
    @title = 'Edit profil'
    haml :user_edit, :locals => {user: session[:current_user]}
  end

  post '/user/edit' do
    verified_params = params.select {|k,_| [:email, :first_name, :last_name].include?(k.to_sym)}
    puts verified_params
    req = PatchRequest.new(session, :api, ApiEndPoint::USER + "/#{params[:id]}",  verified_params)
    req.send
    keep_user_in_session(session[:access_token], session[:refresh_token])
    haml :user_edit, :locals => {user: user, response: req.response.body}
  end
end