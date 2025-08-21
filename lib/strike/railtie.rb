require "rails"
require "strike"

module Strike
  class Railtie < Rails::Railtie
    initializer "strike.configure" do |app|
      Strike.configure do |config|
        # Configuration will automatically pull from Rails credentials
        # No need to explicitly set here - the Configuration class handles it
      end

      # Add rake tasks
      load "strike/tasks.rake" if defined?(Rake)
    end
  end
end