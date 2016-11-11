class Spred
  get '/' do
    req = FindAvailableCastRequest.new
    req.send
    response = req.parse_response
    @casts = response.body.each_with_object([]) do |hashed_cast, array|
      array << SpredCast.from_hash(session[:spred_tokens], hashed_cast)
    end
    haml :'home/index', layout: :'layout/layout'
  end
end
