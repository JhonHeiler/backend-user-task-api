source "https://rubygems.org"

gem "rails", "~> 8.0.2"
gem "pg", "~> 1.1"
gem "puma", ">= 5.0"
# gem "jbuilder"            # opcional, si prefieres JBuilder
# gem "bcrypt", "~> 3.1.7"   # para has_secure_password

gem "tzinfo-data", platforms: %i[ windows jruby ]
gem "solid_cache"
gem "solid_queue"
gem "solid_cable"
gem "bootsnap", require: false
gem "kamal",     require: false
gem "thruster",  require: false

# Añadimos las gems para GraphQL, serialización y APIs
gem "graphql"
gem "active_model_serializers"

group :development, :test do
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"
  gem "brakeman",   require: false
  gem "rubocop-rails-omakase", require: false

  # Testing
  gem "rspec-rails"
  gem "factory_bot_rails"
  gem "faker"

  # Cargar variables de entorno desde .env
  gem "dotenv-rails"
end
