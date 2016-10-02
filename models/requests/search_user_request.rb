class SearchUserRequest < GetRequest
  def initialize(tokens, partial_email)
    req = APIHelper::Request::SEARCH_USER
    super(tokens, req[:service], req[:end_point])
  end
end