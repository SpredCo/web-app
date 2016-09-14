class APIMessage
  def initialize(http_code)
    @http_code = http_code.to_s
    set_message
  end

  def message
    @message
  end
end