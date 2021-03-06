class Spred
  get '/' do
    @active = :welcome
    req = GetHomeFeedRequest.new
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
    end
    haml :'home/index', layout: :'layout/layout'
  end

  get '/search/:value' do
    index = Algolia::Index.new('global')
    options = {
        hitsPerPage: 30
    }
    response = index.search(params[:value], options)
    @result = {tags: [], users: [], casts:[]}
    response['hits'].each do |item|
      item['real_url'] = get_real_url(item)
      @result["#{item['type']}s".to_sym] << item
    end
    p @result
    haml :'home/search', layout: :'layout/layout'
  end

  get '/feed/subscriptions' do
    authenticate!
    @active = :subscription
    req = GetMyFeedRequest.new(session[:spred_tokens])
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
    end
    haml :'home/following', layout: :'layout/layout'
  end

  get '/feed/trending' do
    @active = :trending
    req = GetFeedTrendRequest.new
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
    end
    haml :'home/trending', layout: :'layout/layout'
  end

  def get_real_url(object)
     case object['type']
       when 'tag'
         "#{request.base_url}/#{object['name']}"
       when 'user'
         "#{request.base_url}/#{object['name']}"
       when 'cast'
         "#{request.base_url}/casts/#{object['url']}"
       else
         request.base_url
     end
  end
end
