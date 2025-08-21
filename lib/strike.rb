require "strike/version"
require "strike/client"

# For Rails integration
if defined?(Rails)
  require "strike/railtie"
end

module Strike
  class Configuration
    attr_writer :api_key
    
    def initialize
      @api_key = nil
    end

    def api_key
      @api_key || fetch_rails_api_key || ENV["STRIKE_API_KEY"]
    end

    private

    def fetch_rails_api_key
      return unless defined?(Rails) && Rails.application

      # Try Rails 6+ credentials first
      if Rails.application.respond_to?(:credentials) && Rails.application.credentials.dig(:strike, :api_key)
        return Rails.application.credentials.dig(:strike, :api_key)
      end

      # Try Rails 5.2 secrets
      if Rails.application.secrets.dig(:strike, :api_key)
        return Rails.application.secrets.dig(:strike, :api_key)
      end

      # Fallback to top-level strike_api_key for legacy setups
      if Rails.application.credentials.strike_api_key rescue nil
        return Rails.application.credentials.strike_api_key
      end

      if Rails.application.secrets.strike_api_key rescue nil
        return Rails.application.secrets.strike_api_key
      end

      nil
    rescue => e
      Rails.logger&.error("Strike: Failed to load API key from Rails credentials: #{e.message}") if defined?(Rails)
      nil
    end
  end

  class << self
    attr_writer :configuration

    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield(configuration)
      @client = nil # Reset client when configuration changes
    end

    def client
      @client ||= Client.new(api_key: configuration.api_key)
    end
  end
end