get '/create-cast' do
  authenticate!
  @unread_message_count = synchronize_inbox!
  @title = 'Spred'
  haml :'cast/create', layout: :'layout/create_cast_layout'
end

post '/create-cast' do
  authenticate!
  is_public = params.delete('cast-type') == 'public'
  date_value = params.delete('date-value')
  cast_date = params.delete('date') == 'now' ? 'now' : DateTime.parse(date_value).to_s
  params['tags'] = params['tags'].split(',')
  req = CreateCastRequest.new(session[:spred_tokens], params.delete('name'), params.delete('description'), is_public, cast_date, params)
  req.send
  response = req.parse_response
  p response
  redirect '/'
end

get '/casts/:url' do
  tokens = session[:spred_tokens]
  cast_req = GetCastRequest.new(tokens, params[:url])
  cast_req.send
  @cast = cast_req.parse_response.body
  unless @cast.nil? || @cast.is_a?(APIError)
    @cast = SpredCast.from_hash(tokens, @cast)
    token_req = CastHelper.get_cast_token(tokens, @cast.id)
    @cast_token = CastToken.from_hash(token_req.body)
    haml :'cast/show'
  end
end
