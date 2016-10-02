class DeleteUserRequest < DeleteRequest
  def initialize(tokens, id)
    req = APIHelper::Request::USER_DELETE
    super(tokens, req[:service], req[:end_point] + "/#{id}")
  end
end