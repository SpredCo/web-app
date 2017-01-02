class Spred
  get '/' do
    req = FindAvailableCastRequest.new
    req.send
    response = req.parse_response
    @casts = response.body.each_with_object([]) do |hashed_cast, array|
      array << SpredCast.from_hash(hashed_cast)
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
    @active = :subscription
    haml :'home/following', layout: :'layout/layout'
  end

  get '/feed/trending' do
    @active = :trending
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
