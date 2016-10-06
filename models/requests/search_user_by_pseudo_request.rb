class SearchUserByPseudoRequest < GetRequest
  def initialize(tokens, partial_pseudo)
    req = APIHelper::Request::SEARCH_USER_BY_PSEUDO
    super(tokens, req[:service], "#{req[:end_point]}/#{partial_pseudo}")
  end
end