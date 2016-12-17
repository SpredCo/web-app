class Spred
  include AuthenticationHelper

  get '/user/:id/follow' do
    authenticate!
    user = RemoteUser.find(params[:id])
    response = user.follow(session[:spred_tokens])
    if response.is_a?(APIError)
      @errors = {default: response.message}
      @user = user
      haml :'user/profile', layout: :'layout/layout'
    else
      session[:current_user] = get_current_user_from_token(session[:spred_tokens])
      @user = session[:current_user]
      redirect :"/@#{response.pseudo}"
    end
  end

  get '/user/:id/unfollow' do
    authenticate!
    user = RemoteUser.find(params[:id])
    response = user.unfollow(session[:spred_tokens])
    if response.is_a?(APIError)
      @errors = {default: response.message}
      @user = user
      haml :profile, layout: :'layout/layout'
    else
      session[:current_user] = get_current_user_from_token(session[:spred_tokens])
      @user = session[:current_user]
    end
    redirect :"/@#{response.pseudo}"
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

  get '/user/search/email/:partial_email' do
    users = RemoteUser.find_all_by_email(session[:spred_tokens], params[:partial_email])
    users.map! {|user| user.to_hash}
    @users = JSON.generate(users)
  end

  get '/user/search/pseudo/:partial_pseudo' do
    users = RemoteUser.find_all_by_pseudo(session[:spred_tokens], params[:partial_pseudo])
    users.map! {|user| {id: user.id, pseudo: user.pseudo}}
    @users = JSON.generate(users)
  end

  get '/user/:id/following' do
    @user = RemoteUser.find(params[:id])
    @title = if me?(@user)
               "<a href='#{request.base_url}/profile'>Vous</a> suivez"
             else
               "<a href='#{request.base_url}/@#{@user.pseudo}'>@#{@user.pseudo}</a> suit"
             end
    @followings = @user.following
    haml :'user/following', layout: :'layout/layout'
  end

  get '/user/:id/follower' do
    @user = RemoteUser.find(params[:id])
    @title = if me?(@user)
               "<a href='#{request.base_url}/profile'>Vous</a> êtes suivis"
             else
               "<a href='#{request.base_url}/@#{@user.pseudo}'>@#{@user.pseudo}</a> est suivis"
             end
    @followings = @user.followers
    haml :'user/following', layout: :'layout/layout'
  end

  get '/casts' do
    authenticate!

    haml :'user/cast', layout: :'layout/layout'
  end

  def me?(user)
    session[:current_user] && user.id == session[:current_user].id
  end
end
