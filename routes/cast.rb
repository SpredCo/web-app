class Spred
  get '/create-cast' do
    authenticate!
    @unread_message_count = synchronize_inbox!
    @title = 'Spred'
    @tags = get_tags
    haml :'cast/create', layout: :'layout/create_cast_layout'
  end

  post '/create-cast' do
    authenticate!
    params.delete('validate')
    params.delete('search')
    is_public = params.delete('cast-type') == 'public'
    time_value = params.delete('date-value')
    date_value = params.delete('date-value_submit')
    cast_date = begin
      params.delete('date') == 'now' ? 'now' : DateTime.new(*date_value.split('/').map(&:to_i), *time_value.split(':').map(&:to_i)).to_s
    rescue ArgumentError
      DateTime.now.to_s
    end
    picture = if params['picture']
      pic_path = CastHelper.generate_uniq_cover_url(params['picture'][:type].split('/')[1])
      CastHelper.save_cover(pic_path, params['picture'][:tempfile])
      "#{request.base_url}/#{pic_path}"
    else
      "https://#{request.host}/img/cast.png"
    end

    params['tags'] = params['tags'].split(';')
    if is_public
      params.delete('members')
    else
      params['members'] = params['members'].split(', ')
    end

    response = if params['name'].empty? || params['description'].empty?
      APIError.new(500, 2, 1)
    else
      req = CreateCastRequest.new(session[:spred_tokens], params.delete('name'), params.delete('description'), is_public, cast_date, params.merge({cover_url: picture}))
      req.send
      req.parse_response
    end

    if response.is_a? APIError
      @errors = {default: response.message}
      @tags = get_tags
      haml :'cast/create', layout: :'layout/create_cast_layout'
    else
      redirect '/profile'
    end
  end

  get '/casts/:url' do
    tokens = session[:spred_tokens]
    cast_req = GetCastRequest.new(tokens, params[:url])
    cast_req.send
    @cast = cast_req.parse_response
    if @cast && !@cast.is_a?(APIError)
      @cast = SpredCast.from_hash(@cast.body)
      haml :'cast/show', layout: :'layout/cast_layout'
    else
      not_found
    end
  end

  get '/casts/:token/webview' do
   @token = params[:token]
   haml :'cast/show_webview'
  end

  get '/casts/token/:id' do
    token = CastHelper.get_cast_token(session[:spred_tokens], params[:id])
    JSON.generate(token.is_a?(APIError) ? token.message : token.body)
  end

  get '/profile/casts' do
    authenticate!
    req = GetUserCastsRequest.new(session[:spred_tokens])
    req.send
    response = req.parse_response
    @casts_by_states = {'0' => [], '1' => []}
    if response.is_a? APIError
      redirect '/'
    else
      @casts = response.body.each do |hashed_cast|
        cast = SpredCast.from_hash(hashed_cast)
        if cast.state < 2
          if cast.state == 0
            @casts_by_states['0'] << cast
          else
            @casts_by_states['1'] << cast
          end
        end
      end
      haml :'cast/mine', layout: :'layout/cast_layout'
    end
  end

  get '/casts/:id/remind' do
    authenticate!
    req = RemindCastRequest.new(session[:spred_tokens], params[:id])
    req.send
    response = req.parse_response
    if response.is_a? APIError
      not_found
    else
      redirect back
    end
  end

  get '/casts/:id/unremind' do
    authenticate!
    req = UnremindCastRequest.new(session[:spred_tokens], params[:id])
    req.send
    response = req.parse_response
    if response.is_a? APIError
      not_found
    else
      redirect back
    end
  end

  get '/casts/:id/delete' do
    authenticate!
    req = DeleteCastRequest.new(session[:spred_tokens], params[:id])
    req.send
    response = req.parse_response
    if response.is_a? APIError
      not_found
    else
      redirect '/profile'
    end
  end

  def get_tags
    req = GetTagsRequest.new
    req.send
    response = req.parse_response.body
    response.each_with_object([]) do |tag_hash, tags|
      tags << Tag.from_hash(tag_hash)
    end
  end
end
