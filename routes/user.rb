class Spred
  include AuthenticationHelper

  get '/user/:id/show' do
    authenticate!
    @user = RemoteUser.find(session[:spred_tokens], params[:id])
    if @user.is_a?(APIError)
      @errors = {default: response.message}
      haml :index
    else
      @following_user = session[:current_user].following.include?(@user.id)
      haml :user_show
    end
  end

  get '/user/:id/edit' do
    authenticate!
    @title = 'Edit profil'
    @user = session[:current_user]
    haml :user_edit
  end

  post '/user/edit' do
    authenticate!
    verified_params = params.select {|k,_| [:email, :first_name, :last_name].include?(k.to_sym)}
    verified_params = verified_params.delete_if{|k,v| session[:current_user][k] == verified_params[k]}
    if params['picture']
      new_pic = "public/profile_pictures/#{session[:current_user]['id']}.#{params['picture'][:type].split('/')[1]}"
      UserHelper.save_profile_picture(new_pic, params['picture'][:tempfile])
      verified_params.merge!({picture_url: "#{request.base_url}/#{UserHelper.build_profile_picture_url(new_pic)}"})
    end
    @user = session[:current_user]
    response = @user.edit!(session[:spred_tokens], verified_params)
    if response.is_a?(APIError)
      @errors = {default: response.message}
      haml :user_edit
    else
      session[:current_user] = @user
      haml :profile
    end
  end

  get '/user/:id/follow' do
    authenticate!
    response = RemoteUser.find(session[:spred_tokens], params[:id]).follow(session[:spred_tokens])
    if response.is_a?(APIError)
      @errors = {default: response.message}
    else
      session[:current_user] = get_current_user_from_token(session[:spred_tokens])
      @user = session[:current_user]
      haml :profile
    end
  end

  get '/user/:id/unfollow' do
    authenticate!
    response = RemoteUser.find(session[:spred_tokens], params[:id]).unfollow(session[:spred_tokens])
    if response.is_a?(APIError)
      @errors = {default: response.message}
    else
      session[:current_user] = get_current_user_from_token(session[:spred_tokens])
      @user = session[:current_user]
      haml :profile
    end
  end

  get '/user/pseudo/check/:pseudo' do
    response = UserHelper.check_pseudo_availability(params[:pseudo])
    if response.is_a? APIError
      JSON.generate(result: 'ko')
    else
      JSON.generate(result: 'ok')
    end
  end

  get '/user/email/check/:email' do
    response = UserHelper.check_email_availability(params[:email])
    if response.is_a? APIError
      JSON.generate(result: 'ko')
    else
      JSON.generate(result: 'ok')
    end
  end

  get '/user/search/:partial_email' do
    request = SearchUserRequest(session[:spred_tokens], params[:partial_email])
    request.send
    request.parse_response
  end
end