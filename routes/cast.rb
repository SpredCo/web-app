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

get '/casts/:name' do
  cast_req = GetCastRequest.new(session[:spred_tokens], params[:name])
  cast_req.send
  @cast = cast_req.parse_response
  puts @cast
  haml :'cast/show', layout: :'layout/cast_layout'
end
