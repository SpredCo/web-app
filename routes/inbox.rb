class Spred
  include AuthenticationHelper

  get '/inbox' do
    request = GetInboxRequest.new(session[:spred_tokens])
    request.send
    response = request.parse_response
    if response.is_a? APIError
      @errors = {default: response.message}
    else
      @inbox = Inbox.from_hash(response.body)
    end
    haml :'inbox/inbox', layout: :'layout/inbox_layout'
  end

  get '/inbox/conversation/:conversation_id/message/:message_id' do
    request = GetMessageRequest.new(session[:spred_tokens], params[:conversation_id], params[:message_id])
    request.send
    response = request.parse_response
    if response.is_a? APIError
      @errors = {default: response.message}
    else
      @message = Message.from_hash(response.body)
    end  end

  get '/inbox/conversation/new' do
    haml :'inbox/create_conversation', layout: :'layout/inbox_layout'
  end

  post '/inbox/conversation/:id/reply' do
    current_user = session[:current_user]
    tokens = session[:spred_tokens]
    response = Conversation.find(tokens, params[:id]).push(Message.new(conv_id, "@#{current_user.pseudo}", params[:content]))
    if response.is_a? APIError
      @errors = {default: response.message}
    else
      haml :'inbox/inbox', layout: :'layout/inbox_layout'
    end
  end

  post '/inbox/conversation/new' do
    current_user = session[:current_user]
    tokens = session[:spred_tokens]
    members = params[:members]
    members << "@#{current_user.pseudo}"
    response = current_user.inbox(tokens).create_conversation(tokens, members, params[:object], params[:content])
    if response.is_a? APIError
      @errors = {default: response.message}
    else
      haml :'inbox/inbox', layout: :'layout/inbox_layout'
    end
  end

  get '/inbox/conversation/:id' do
    request = GetConversationRequest.new(session[:spred_tokens], params[:id])
    request.send
    response = request.parse_response
    if response.is_a? APIError
      @errors = {default: response.message}
    else
      @conversation = Conversation.from_hash(response.body)
      #@conversation.read!(session[:spred_tokens]) if @conversation.unread?
    end
  end
end
