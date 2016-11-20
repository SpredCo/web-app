class GetCastRequest < GetRequest
  def initialize(tokens, name)
    req = APIHelper::Request::GUEST_CAST
    super(tokens, req[:service], "#{req[:end_point]}/#{name}")
  end
end
