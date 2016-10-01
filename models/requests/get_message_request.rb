class GetMessageRequest < GetRequest
  def initialize(tokens, conv_id, msg_id)
    req = Api::Request::MESSAGE_GET
    super(tokens, req[:service], req[:end_point] + "/#{conv_id}/message/#{msg_id}")
  end
end