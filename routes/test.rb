class Spred
  get '/test/inbox' do
    haml "#{session[:current_user].inbox(session[:spred_tokens]).conversations.inspect}"
  end

  get '/test/inbox/conversation/:id' do
    haml "#{session[:current_user].inbox(session[:spred_tokens]).conversation(params[:id]).inspect}"
  end

  get '/test/new_conv' do
    haml :new_conv
  end

  post '/test/new_conv' do
    current_user = session[:current_user]
    tokens = session[:spred_tokens]
    users = params[:users].split(';')
    users << "@#{current_user.pseudo}"
    p users
    users.map! {|user| RemoteUser.find(tokens, user).id}
    p users
    response = current_user.inbox(tokens).create_conversation(tokens, users, params[:object], params[:msg])
    haml "#{response}"
  end
end