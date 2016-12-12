class Spred
  get '/#:name' do
    req = GetCastsFromTagRequest.new(params[:tag])
    req.send
    response = req.parse_response
    @casts_by_states = {'0' => [], '1' => []}
    if response.is_a? APIError
      redirect '/'
    else
      @casts = response.body.each do |hashed_cast|
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
end
