class GetInboxRequest < GetRequest
  def initialize(tokens)
    req = APIHelper::Request::INBOX
    super(tokens, req[:service], req[:end_point])
  end
end