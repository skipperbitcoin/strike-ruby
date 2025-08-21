# lib/strike/railtie.rb
require "rails"

module Strike
  class Railtie < Rails::Railtie
    initializer "strike.ensure_loaded", before: :finisher_hook, priority: :high do |app|
      # Force require strike if not already loaded
      unless defined?(Strike)
        begin
          require "strike-api"
          Rails.logger.info("Strike gem manually required during Rails initialization")
        rescue => e
          Rails.logger.error("Failed to require Strike: #{e.message}")
          raise "Strike gem failed to load: #{e.message}"
        end
      end
    end

    # Keep your existing configuration initializer
    initializer "strike.configure", after: "strike.ensure_loaded" do |app|
      Strike.configure do |config|
        config.api_key ||= begin
          creds = Rails.application.try(:credentials)
          secrets = Rails.application.try(:secrets)
          
          if creds&.respond_to?(:dig)
            creds.dig(:strike, :api_key) || creds.dig(:strike_api_key)
          elsif secrets&.respond_to?(:dig)
            secrets.dig(:strike, :api_key) || secrets.dig(:strike_api_key)
          end || ENV["STRIKE_API_KEY"]
        end
      end
      
      # Production safety check
      if Rails.env.production? && Strike.configuration.api_key.nil?
        raise "Strike API key not configured! " \
              "Set STRIKE_API_KEY or configure in Rails credentials."
      end
    end

    # Keep your rake tasks
    rake_tasks do
      Dir[File.expand_path("../tasks/*.rake", __FILE__)].each { |f| load f }
    end
  end
end