class Spred
  include AuthenticationHelper

  get '/inbox' do
    authenticate!
    @inbox = session[:current_user].inbox(session[:spred_tokens])
    if @inbox.is_a? APIError
      @errors = {default: @inbox.message}
    end
    haml :'inbox/inbox', layout: :'layout/inbox_layout'
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
    conv_id = params[:id]
    response = current_user.inbox(tokens).conversation(conv_id).push(tokens, Message.new(conv_id, "@#{current_user.pseudo}", params[:content]))
    if response.is_a? APIError
      @errors = {default: response.message}
    else
      redirect '/inbox'
    end
  end

  post '/inbox/conversation/new' do
    authenticate!
    current_user = session[:current_user]
    tokens = session[:spred_tokens]
    members_pseudo = params[:members].split(', ')
    members = {}
    invalid_members = {}
    members_pseudo.each do |member|
      user = RemoteUser.find(tokens, member)
      if user.is_a? APIError
        invalid_members[member] = user
      else
        members[member] = user.id
      end
    end
    members[current_user.pseudo] = current_user.id
    if invalid_members.empty?
      response = current_user.inbox(tokens).create_conversation(tokens, members.values, params[:object], params[:content])
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
