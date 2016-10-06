class SearchUserByEmailRequest < GetRequest
  def initialize(tokens, partial_email)
    req = APIHelper::Request::SEARCH_USER_BY_EMAIL
    super(tokens, req[:service], "#{req[:end_point]}/#{partial_email}")
  end
end