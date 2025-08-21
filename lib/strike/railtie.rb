# lib/strike/railtie.rb
require "rails"

module Strike
  class Railtie < Rails::Railtie
    initializer "strike.configure" do |app|
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
    end

    # Keep your rake tasks
    rake_tasks do
      Dir[File.expand_path("../tasks/*.rake", __FILE__)].each { |f| load f }
    end
  end
end