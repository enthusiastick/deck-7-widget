require "dotenv"
require "google/apis/calendar_v3"
require "google/api_client/client_secrets"
require "json"
require "sinatra"

require_relative "google_calendar"
require_relative "now"

Dotenv.load
enable :sessions
set :session_secret, ENV["SECRET_KEY_BASE"]

get "/" do
  redirect to("/oauth2callback") unless session.has_key?(:credentials)
  begin
    client_opts = JSON.parse(session[:credentials])
    auth_client = Signet::OAuth2::Client.new(client_opts)
    @items = GoogleCalendar.fetch_events(auth_client)
    @today = Now.eastern.strftime('%A, %B %-d, %Y')
    erb :index
  rescue
    redirect to("/reset")
  end
end

get("/oauth2callback") do
  client_secrets = GoogleCalendar.client_secrets(request.base_url)
  auth_client = client_secrets.to_authorization
  auth_client.update!(
    scope: "https://www.googleapis.com/auth/calendar.readonly",
    redirect_uri: url("/oauth2callback"))
  if request["code"] == nil
    auth_uri = auth_client.authorization_uri.to_s
    redirect to(auth_uri)
  else
    auth_client.code = request["code"]
    auth_client.fetch_access_token!
    auth_client.client_secret = nil
    session[:credentials] = auth_client.to_json
    redirect to("/")
  end
end

get("/reset") do
  session.clear
  redirect to("/")
end
