require "rails/generators"

module Strike
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("templates", __dir__)
      desc "Creates an initializer for Strike"

      def create_initializer_file
        template "strike.rb", "config/initializers/strike.rb"
      end

      def show_readme
        readme "README" if behavior == :invoke
      end
    end
  end
end