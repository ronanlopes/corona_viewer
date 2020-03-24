require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module RailsProjetoBase
  class Application < Rails::Application


    config.autoload_paths += %W(#{config.root}/lib #{config.root} #{config.root}/app #{config.root}/app/api_helper)

		config.time_zone = 'Brasilia'

		config.exceptions_app = self.routes

    config.i18n.default_locale = :"pt-BR"

    config.generators do |g|
      g.template_engine :custom
      g.assets = false
    end


  end
end
