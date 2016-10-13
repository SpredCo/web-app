class CreateMessageRequest < PostRequest
  def initialize(tokens, conv_id, message)
    req = APIHelper::Request::MESSAGE_CREATE
    super(tokens, req[:service], "#{req[:end_point]}/#{conv_id}/message", {content: message})
  end
end