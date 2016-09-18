class Spred < Sinatra::Application

  get '/user/:id/show' do
    req = GetRequest.new(session, :api, ApiEndPoint::USER + "/#{params[:id]}")
    response = req.response
    if response.is_a?(APIError)
      @errors[:error] = response.message
      haml :main
    end
    haml :user_show, :locals => {user: user, response: response.body, following_user: session[:current_user]['following'].include?(user['id'])}
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
    response = req.send
    if response.is_a?(APIError)
      @errors[:error] = response.message
      haml :user_edit
    end
    keep_user_in_session(session[:current_user].fetch(:access_token, nil), session[:current_user].fetch(:refresh_token, nil))
    haml :profile, :locals => {user: session[:current_user], response: response.body}
  end

  post '/user/:id/follow' do
    req = PostRequest.new(session, :api, ApiEndPoint::USER + "/#{params[:id]}/follow")
    response = req.send
    if response.is_a?(APIError)
      @errors[:default] = response.message
      haml :user_show
    end
  end

  post '/user/:id/unfollow' do
    req = PostRequest.new(session, :api, ApiEndPoint::USER + "/#{params[:id]}/unfollow")
    response = req.send
    if response.is_a?(APIError)
      @errors[:default] = response.message
      haml :user_show
    end
  end

  get '/user/pseudo/check/:pseudo' do
    if User.is_pseudo_available?(session, params[:pseudo])
      JSON.generate(result: 'ko')
    else
      JSON.generate(result: 'ok')
    end
  end

  get '/user/email/check/:email' do
    if User.is_email_available?(session, params[:email])
      JSON.generate(result: 'ko')
    else
      JSON.generate(result: 'ok')
    end
  end

  get '/user/search/:partial_email' do
    req = GetRequest.new(session, :api, ApiEndPoint::SEARCH_BY_EMAIL + "/#{params[:email]}")
    req.send
  end
end