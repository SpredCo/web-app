class Spred < Sinatra::Application

  get '/user/:id/show' do
    req = GetRequest.new(session, :api, ApiEndPoint::USER + "/#{params[:id]}")
    req.send
    user = req.response.body
    haml :user_show, :locals => {user: user, response: req.response.body, following_user: session[:current_user]['following'].include?(user['id'])}
  end

  get '/user/:id/edit' do
    @title = 'Edit profil'
    haml :user_edit, :locals => {user: session[:current_user]}
  end

  post '/user/edit' do
    verified_params = params.select {|k,_| [:email, :first_name, :last_name].include?(k.to_sym)}
    verified_params = verified_params.delete_if{|k,v| session[:current_user][k] == verified_params[k]}
    if params['picture']
      new_pic = "public/profile_pictures/#{session[:current_user]['id']}.#{params['picture'][:type].split('/')[1]}"
      User.save_profile_picture(new_pic, params['picture'][:tempfile])
      verified_params.merge!({picture_url: "#{request.base_url}/#{User.build_profile_picture_url(new_pic)}"})
    end
    req = PatchRequest.new(session, :api, ApiEndPoint::USER + "/#{params[:id]}",  verified_params)
    req.send
    keep_user_in_session(session[:current_user].fetch(:access_token, nil), session[:current_user].fetch(:refresh_token, nil))
    haml :profile, :locals => {user: session[:current_user], response: req.response.body}
  end

  post '/user/:id/follow' do
    req = PostRequest.new(session, :api, ApiEndPoint::USER + "/#{params[:id]}/follow")
    req.send
  end

  post '/user/:id/unfollow' do
    req = PostRequest.new(session, :api, ApiEndPoint::USER + "/#{params[:id]}/unfollow")
    req.send
  end
end