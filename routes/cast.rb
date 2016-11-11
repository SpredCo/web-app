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

get '/casts/:name' do
  cast_req = GetCastRequest.new(session[:spred_tokens], params[:name])
  cast_req.send
  @cast = cast_req.parse_response
  unless @cast.is_a?(APIError)
    token_req = CastHelper.get_cast_token(session[:spred_tokens], @cast.id)
    token_req.send
    @cast_token = CastToken.from_hash(token_req.parse_response)
  end
  haml :'cast/show'
end
