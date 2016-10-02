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
end