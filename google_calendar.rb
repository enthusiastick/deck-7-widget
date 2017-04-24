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
    Time.zone = ENV["TIMEZONE_STRING"]
    service = Google::Apis::CalendarV3::CalendarService.new
    service.client_options.application_name = "Deck 7 Widget"

    calendar_id = ENV["GOOGLE_CALENDAR_ID"]
    response = service.list_events(
      calendar_id,
      options: { authorization: auth_client },
      single_events: true,
      order_by: "startTime",
      time_min: Time.zone.now.at_beginning_of_day.iso8601,
      time_max: Time.zone.now.at_end_of_day.iso8601)

    result = Array.new
    response.items.each do |item|
      result << item if relevant(item)
    end
    result
  end

  def self.relevant(event)
    !event.start.date_time.nil? &&
    event.start.date_time.to_date.day == Time.zone.now.day &&
    !event.summary.downcase.include?("mock")
  end
end
