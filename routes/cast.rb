class Spred
  get '/create-cast' do
    authenticate!
    @unread_message_count = synchronize_inbox!
    @title = 'Spred'
    haml :'cast/create', layout: :'layout/create_cast_layout'
  end

  post '/create-cast' do
    authenticate!
    params.delete('validate')
    params.delete('search')
    is_public = params.delete('cast-type') == 'public'
    date_value = params.delete('date-value')
    cast_date = params.delete('date') == 'now' ? 'now' : DateTime.parse(date_value).to_s

    picture = if params['picture']
                pic_path = CastHelper.generate_uniq_cover_url(params['picture'][:type].split('/')[1])
                CastHelper.save_cover(pic_path, params['picture'][:tempfile])
                "#{request.base_url}/#{pic_path}"
              end

    params['tags'] = params['tags'].split(',')
    req = CreateCastRequest.new(session[:spred_tokens], params.delete('name'), params.delete('description'), is_public, cast_date, params.merge({cover_url: picture}))
    req.send
    req.parse_response
    redirect '/'
  end

  get '/casts/:url' do
    tokens = session[:spred_tokens]
    cast_req = GetCastRequest.new(tokens, params[:url])
    cast_req.send
    @cast = cast_req.parse_response.body
    if @cast && !@cast.is_a?(APIError)
      @cast = SpredCast.from_hash(tokens, @cast)
      haml :'cast/show', layout: :'layout/cast_layout'
    else
      redirect '/'
    end
  end

  get '/casts/token/:id' do
    token = CastHelper.get_cast_token(session[:spred_tokens], params[:id])
    JSON.generate(token.body)
  end

  get '/profile/casts' do
    authenticate!
    req = GetUserCastsRequest.new(session[:spred_tokens])
    req.send
    response = req.parse_response
    if response.is_a? APIError
      redirect '/'
    else
      @casts = response.body.each_with_object([]) do |hashed_cast, array|
        array << SpredCast.from_hash(session[:spred_tokens], hashed_cast)
      end
      haml :'cast/mine', layout: :'layout/cast_layout'
    end
  end
end
