class FindAvailableCastRequest < GetRequest
  def initialize
    req = APIHelper::Request::CASTS
    super(nil, req[:service], req[:end_point])
  end
end