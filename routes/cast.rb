get '/create-cast' do
  authenticate!
  @unread_message_count = synchronize_inbox!
  @title = 'Spred'
  haml :'cast/create', layout: :'layout/layout'
end

post '/create-cast' do
  authenticate!
  req = CreateCastRequest.new(session[:spred_tokens], params[:name], params[:description], params[:is_public], params[:date])
  req.send
  response = req.parse_response
  p response
end

get '/join-cast/:id' do
  if session[:spred_tokens].is_a? TokenBox
    req = GetCastTokenRequest.new(session[:spred_tokens], params[:id], true)
  else
    req = GetGuestCastTokenRequest.new(session[:spred_tokens], params[:id])
  end
  req.send
  response = req.parse_response
  p response
end