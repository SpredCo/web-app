class Spred
  include AuthenticationHelper

  get '/profile' do
    authenticate!
    @user = session[:current_user]
    haml :profile
  end

  get '/profile/edit' do
    haml :edit_profile
  end

  post '/profile/edit' do
    authenticate!
    verified_params = params.select {|k,_| [:email, :first_name, :last_name, :pseudo].include?(k.to_sym)}
    verified_params = verified_params.delete_if{|k,v| session[:current_user].send(k) == v}
    if params['profile_picture']
      new_pic = "public/profile_pictures/#{session[:current_user].id}.#{params['profile_picture'][:type].split('/')[1]}"
      UserHelper.save_profile_picture(new_pic, params['profile_picture'][:tempfile])
      verified_params[:picture_url] = "#{request.base_url}/#{UserHelper.build_profile_picture_url(new_pic)}"
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

  get '/@:id' do
    authenticate!
    @user = RemoteUser.find(session[:spred_tokens], params[:id])
    if @user.is_a?(APIError)
      @errors = {default: @user.message}
      haml :index
    else
      @following_user = session[:current_user].following.include?(@user.id)
      haml :profile
    end
  end
end