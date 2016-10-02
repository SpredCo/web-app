class Spred
  include AuthenticationHelper

  get '/profile' do
    authenticate!
    @user = session[:current_user]
    haml :profile
    end
end