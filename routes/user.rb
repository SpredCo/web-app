class Spred < Sinatra::Application
  get '/user/:id' do
    req = GetRequest.new(session, :api, ApiEndPoint::GET_USER + "/#{params[:id]}")
    req.send
    user = req.response.body.reject { |k,_| User::PRIVATE_FIELDS.include?(k) }
    haml :user_show, :locals => {user: user}
  end

  get '/user/edit/:id' do
    haml :user_edit, :locals => {user: session[:current_user]}
  end
end