# Configure the Strike API client
Strike.configure do |config|
  # Your Strike API key (required)
  # Get this from: https://dashboard.strike.me/developers
  config.api_key = ENV["STRIKE_API_KEY"]
end