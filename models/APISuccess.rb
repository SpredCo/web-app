class APISuccess < APIMessage

  def initialize(http_code)
    super(http_code)
  end

  def set_message
    @message = SUCCESS[@http_code]
  end
end