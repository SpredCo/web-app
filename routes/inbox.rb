class Spred
  include AuthenticationHelper

  get '/inbox' do
    puts 'ok'
    request = GetInboxRequest.new(session[:spred_tokens])
    request.send
    response = request.parse_response
    if response.is_a? APIError
      @errors[:default] = @response.message
    else
      @inbox = Inbox.from_hash(response.body)
    end
  end

  get '/inbox/conversation/:id' do
    request = GetConversationRequest.new(session[:spred_tokens], params[:id])
    request.send
    response = request.parse_response
    if response.is_a? APIError
      @errors[:default] = @response.message
    else
      @conversation = Conversation.from_hash(response.body)
    end  end

  get '/inbox/conversation/:conversation_id/message/:message_id' do
    request = GetMessageRequest.new(session[:spred_tokens], params[:conversation_id], params[:message_id])
    request.send
    response = request.parse_response
    if response.is_a? APIError
      @errors[:default] = @response.message
    else
      @message = Message.from_hash(response.body)
    end  end

  post '/inbox/conversation' do
    request = CreateConversationRequest.new(session[:spred_tokens], params[:conversation])
    request.send
    response = request.parse_response
    if @response.is_a? APIError
      @errors[:default] = response.message
    else
      haml :inbox
    end
  end

  post '/inbox/conversation/:id' do
    request = CreateMessageRequest.new(session[:spred_tokens], params[:id], params[:message])
    request.send
    response = request.parse_response
    if response.is_a? APIError
      @errors[:default] = response.message
    else
      haml :inbox
    end
  end
end
