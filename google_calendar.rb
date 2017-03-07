class GoogleCalendar
  def self.client_secrets(base_url)
    Google::APIClient::ClientSecrets.new(
      {
        web: {
          client_id: ENV["GOOGLE_CLIENT_ID"],
          client_secret: ENV["GOOGLE_SECRET_KEY"],
          redirect_uris: ["#{base_url}/oauth2callback"],
          auth_uri: "https://accounts.google.com/o/oauth2/auth",
          token_uri: "https://accounts.google.com/o/oauth2/token"
        }
      }
    )
  end

  def self.fetch_events(auth_client)
    service = Google::Apis::CalendarV3::CalendarService.new
    service.client_options.application_name = "Deck 7 Widget"

    calendar_id = ENV["GOOGLE_CALENDAR_ID"]
    now = Now.eastern
    response = service.list_events(
      calendar_id,
      options: { authorization: auth_client },
      single_events: true,
      order_by: "startTime",
      time_min: Time.new(now.year, now.month, now.day, 00, 00, 00).iso8601,
      time_max: Time.new(now.year, now.month, now.day, 23, 59, 59).iso8601)

    response.items
  end
end
