class CreateCastRequest < PostRequest
  # unrequired_params: tags, user_capacity, members, duration
  def initialize(tokens, name, description, is_public, date, unrequired_params={})
    req = APIHelper::Request::MY_CAST
    super(tokens, req[:service], req[:end_point],
          {name: name, description: description, is_public: is_public, date: date}.merge(unrequired_params))
  end
end
