class Spred
  get '/' do
    @unread_message_count = synchronize_inbox! if session[:spred_tokens]
    @title = 'Spred'
    haml :'home/index', layout: :'layout/layout'
  end
end