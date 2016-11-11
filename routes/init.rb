require_relative 'main'
require_relative 'login'
require_relative 'signup'
require_relative 'user'
require_relative 'profile'
require_relative 'inbox'
require_relative 'cast'

require_relative 'test' unless production?

class Spred
  include AuthenticationHelper
   before do
     @unread_message_count = synchronize_inbox! if session[:spred_tokens]
     @title = 'Spred'
   end
end