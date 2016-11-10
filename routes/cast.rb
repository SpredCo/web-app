get '/create-cast' do
  authenticate!
  haml :'cast/create'
end

post '/create-cast' do
  authenticate!
  req = CreateCastRequest.new(session[:spred_tokens], params[:name], params[:description], params[:is_public], params[:date])
  req.send
  response = req.parse_response
  p response
end

get '/cast/:id' do
  authenticate!
  req = GetCastTokenRequest.new(session[:spred_tokens], params[:id], true)
  req.send
  response = req.parse_response
  p response
end