class Spred
  get '/tags/:name' do
    req = GetCastsFromTagRequest.new(params[:name])
    req.send
    response = req.parse_response
    sub_req = CheckTagSubscriptionRequest.new(tokens, params[:name])
    sub_req.send
    sub_response = sub_req.parse_response
    @is_following = sub_response.body['result']
    @tag = params[:name]
    @casts_by_states = {'0' => [], '1' => []}
    if response.is_a? APIError
      not_found
    else
      response.body.each do |hashed_cast|
        cast = SpredCast.from_hash(hashed_cast)
        if cast.state < 2
          if DateTime.parse(cast.date) < DateTime.now
            @casts_by_states['0'] << cast
          else
            @casts_by_states['1'] << cast
          end
        end
      end
      haml :'cast/by_tag', layout: :'layout/cast_layout'
    end
  end

  get 'tags/:name/subscribe' do
    req = RegisterTagRequest.new(tokens, params[:name])
    req.send
    response = req.parse_response
    if response.is_a? APIError
      not_found
    else
      redirect "/tags/#{params[:name]}"
    end
  end

  get 'tags/:name/unsubscribe' do
    req = UnregisterTagRequest.new(tokens, params[:name])
    req.send
    response = req.parse_response
    if response.is_a? APIError
      not_found
    else
      redirect "/tags/#{params[:name]}"
    end
  end
end
