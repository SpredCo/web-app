get '/create-cast' do
  authenticate!
  @unread_message_count = synchronize_inbox!
  @title = 'Spred'
  haml :'cast/create', layout: :'layout/layout'
end

post '/create-cast' do
  authenticate!
  is_public = params.delete('cast_type') == 'public'
  cast_date = params.delete('date') == 'now' ? 'now' : DateTime.parse(params.delete('date-value')).to_s
  params['tags'] = params['tags'].split(',')
  req = CreateCastRequest.new(session[:spred_tokens], params.delete('name'), params.delete('description'), is_public, cast_date, params)
  req.send
  response = req.parse_response
  p response
end

get '/casts/:url' do
  cast_req = GetCastRequest.new(session[:spred_tokens], params[:url])
  cast_req.send
  @cast = cast_req.parse_response.body
  unless @cast.nil? || @cast.is_a?(APIError)
    token_req = CastHelper.get_cast_token(session[:spred_tokens], @cast['id'])
    @cast_token = CastToken.from_hash(token_req.body)
    haml :'cast/show'
  end
end
