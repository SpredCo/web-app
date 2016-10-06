class Spred
  include AuthenticationHelper

  get '/user/:id/follow' do
    authenticate!
    response = RemoteUser.find(session[:spred_tokens], params[:id]).follow(session[:spred_tokens])
    if response.is_a?(APIError)
      @errors = {default: response.message}
    else
      session[:current_user] = get_current_user_from_token(session[:spred_tokens])
      @user = session[:current_user]
      haml :'user/profile', layout: :'layout/layout'
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
      haml :'user/profile', layout: :'layout/layout'
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