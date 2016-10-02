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

  get '/:id' do
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