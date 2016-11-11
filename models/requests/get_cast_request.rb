class GetCastRequest < GetRequest
  def initialize(tokens, name)
    req = APIHelper::Request::CAST
    super(tokens, req[:service], "#{req[:end_point]}/#{name}")
  end
end
