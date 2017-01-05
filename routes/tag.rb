class Spred
  get '/tags/:name' do
    name_without_hash = get_name_without_hash(params[:name])
    req = GetCastsFromTagRequest.new(params[:name])
    req.send
    response = req.parse_response
    @tag = Tag.find_by_name(name_without_hash)
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
      haml :'cast/by_tag', layout: :'layout/layout'
    end
  end

  get '/tags/:name/subscribe' do
    authenticate!
    name_without_hash = get_name_without_hash(params[:name])
    tag = Tag.find_by_name(name_without_hash)
    response = session[:current_user].add_tag(session[:spred_tokens], tag.id)
    if response.is_a? APIError
      not_found
    else
      redirect "/tags/#{tag.name}"
    end
  end

  get '/tags/:name/unsubscribe' do
    authenticate!
    name_without_hash = get_name_without_hash(params[:name])
    tag = Tag.find_by_name(name_without_hash)
    response = session[:current_user].remove_tag(session[:spred_tokens], tag.id)
    if response.is_a? APIError
      not_found
    else
      redirect "/tags/#{tag.name}"
    end
  end

  def get_name_without_hash(name)
    if name.start_with?('#')
      name[1..-1]
    else
      name
    end
  end
end
