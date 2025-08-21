# lib/strike/railtie.rb
require "rails"

module Strike
  class Railtie < Rails::Railtie
    # Load VERY late in the Rails initialization process
    initializer "strike.configure", after: :finisher_hook do |app|
      # Verify Rails.application is fully available
      if !defined?(Rails.application) || Rails.application.nil?
        Rails.logger&.error("[STRIKE] Rails.application not available during initialization!")
        next
      end
      
      Strike.configure do |config|
        # Safe credentials access
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
    end

    rake_tasks do
      Dir[File.expand_path("../tasks/*.rake", __FILE__)].each { |f| load f }
    end
  end
end