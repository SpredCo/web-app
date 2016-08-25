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
    verified_params = verified_params.delete_if{|k,v| session[:current_user][k] == verified_params[k]}
    puts "verified params: #{verified_params}"
    req = PatchRequest.new(session, :api, ApiEndPoint::USER + "/#{params[:id]}",  verified_params)
    req.send
    puts "current user: #{session[:current_user]}, type: #{session[:current_user].class.name}"
    keep_user_in_session(session[:current_user].fetch(:access_token, nil), session[:current_user].fetch(:refresh_token, nil))
    haml :user_edit, :locals => {user: session[:current_user], response: req.response.body}
  end
end