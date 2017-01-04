class DeleteCastRequest < DeleteRequest
  def initialize(tokens, id)
    req = APIHelper::Request::MY_CAST
    super(tokens, req[:service], "#{req[:end_point]}/#{id}")
  end
end
