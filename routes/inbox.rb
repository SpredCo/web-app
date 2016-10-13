class Spred
  include AuthenticationHelper

  get '/inbox' do
    authenticate!
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
    end
  end

  get '/inbox/conversation/new' do
    authenticate!
    haml :'inbox/create_conversation', layout: :'layout/inbox_layout'
  end

  get '/inbox/conversation/:id/reply' do
    authenticate!
    @conversation = session[:current_user].inbox(session[:spred_tokens]).conversation(params[:id])
    haml :'inbox/reply', layout: :'layout/inbox_layout'
  end

  post '/inbox/conversation/:id/reply' do
    authenticate!
    current_user = session[:current_user]
    tokens = session[:spred_tokens]
    response = Conversation.find(tokens, params[:id]).push(Message.new(conv_id, "@#{current_user.pseudo}", params[:content]))
    if response.is_a? APIError
      @errors = {default: response.message}
    else
      haml :'inbox/reply', layout: :'layout/inbox_layout'
    end
  end

  post '/inbox/conversation/new' do
    authenticate!
    current_user = session[:current_user]
    tokens = session[:spred_tokens]
    members_pseudo = params[:members].split(', ')
    members_pseudo << "@#{current_user.pseudo}"
    members = {}
    members_pseudo.each {|member| members[member] = RemoteUser.find(tokens, member)}
    invalid_members = members_pseudo.select {|_, v| v.is_a? APIError}
    if invalid_members.empty?
      response = current_user.inbox(tokens).create_conversation(tokens, members.values.select{|member| !member.is_a?(APIError)}.map(&:id), params[:object], params[:content])
      if response.is_a? APIError
        @errors = {default: response.message}
        haml :'inbox/create_conversation', layout: :'layout/inbox_layout'
      else
        redirect '/inbox'
      end
    else
      @errors = {}
      invalid_members.each do |k, v|
        @errors[k] = v.message
      end
      haml :'inbox/create_conversation', layout: :'layout/inbox_layout'
    end
  end

  get '/inbox/conversation/:id' do
    authenticate!
    request = GetConversationRequest.new(session[:spred_tokens], params[:id])
    request.send
    response = request.parse_response
    if response.is_a? APIError
      @errors = {default: response.message}
    else
      @conversation = Conversation.from_hash(response.body)
      @conversation.read!(session[:spred_tokens]) if @conversation.unread?
    end
    haml :'inbox/conversation'
  end
end
