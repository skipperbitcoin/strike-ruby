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

      # Rails 6+ preferred pattern
      if Rails.application.respond_to?(:credentials) && 
         Rails.application.credentials.respond_to?(:dig)
        
        # Try structured credentials first (most secure)
        if api_key = Rails.application.credentials.dig(:strike, :api_key)
          return api_key
        end
        
        # Try top-level key as fallback
        if api_key = Rails.application.credentials.dig(:strike_api_key)
          return api_key
        end
      end

      # Rails 5.2 secrets
      if Rails.application.respond_to?(:secrets) &&
         Rails.application.secrets.respond_to?(:dig)
        
        if api_key = Rails.application.secrets.dig(:strike, :api_key)
          return api_key
        end
        
        if api_key = Rails.application.secrets.dig(:strike_api_key)
          return api_key
        end
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