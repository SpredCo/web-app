class Spred
  module Authentication
    def authenticate!
      redirect '/' unless session[:current_user] && session[:current_user].empty?
    end
  end
end