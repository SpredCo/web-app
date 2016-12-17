class Spred
  include AuthenticationHelper

  get '/profile' do
    authenticate!
    @user = session[:current_user]
    haml :'user/profile', layout: :'layout/layout'
  end

  get '/following' do
    authenticate!
    @title = 'Les personnes que vous suivez'
    @followings = session[:current_user].following(session[:spred_tokens])
    haml :'user/following', layout: :'layout/layout'
  end

  get '/follower' do
    authenticate!
    @title = 'Les personnes qui vous suivent'
    @followings = session[:current_user].followers(session[:spred_tokens])
    haml :'user/following', layout: :'layout/layout'
  end

  get '/profile/edit' do
    authenticate!
    haml :'user/edit_profile', layout: :'layout/layout'
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
      haml :'user/edit_profile', layout: :'layout/layout'
    else
      session[:current_user] = @user
      haml :'user/profile', layout: :'layout/layout'
    end
  end

  get '/@:id' do
    @current_user = session[:current_user]
    @user = RemoteUser.find("@#{params[:id]}")
    if @user.is_a?(APIError)
      @errors = {default: @user.message}
      not_found
    else
      @is_following = @current_user.is_following?(session[:spred_tokens], @user.id) if @current_user
      haml :'user/profile', layout: :'layout/layout'
    end
  end
end
