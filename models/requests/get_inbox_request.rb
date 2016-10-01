class GetInboxRequest < GetRequest
  def initialize(tokens)
    req = Api::Request::INBOX
    super(tokens, req[:service], req[:end_point])
  end
end