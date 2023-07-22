source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.1.2"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.0.4", ">= 7.0.4.2"

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem "sprockets-rails", "~> 3.4.2"

# Use postgresql as the database for Active Record
gem "pg", "~> 1.1"

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", "~> 5.0"

# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem "importmap-rails", "~> 1.1.5"

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails", "~> 1.4.0"

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails", "~> 1.2.1"

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jbuilder", "~> 2.11.5"

# Use Redis adapter to run Action Cable in production
# gem "redis", "~> 4.0"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", "~> 1.16.0", require: false

# Use Sass to process CSS
# gem "sassc-rails"

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
gem "image_processing", "~> 1.2"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
  gem 'dotenv-rails', "~> 2.8.1"
  gem 'pry', '~> 0.13.1'
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console", "~> 4.2.0"

  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  # gem "rack-mini-profiler"

  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"
  gem 'annotate', "~> 3.2.0"
  gem 'bullet', "~> 7.0.7"
  gem 'letter_opener', "~> 1.8.1"
  gem 'letter_opener_web', "~> 2.0"
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem 'simplecov', "~> 0.22", require: false
  gem "capybara", "~> 3.38"
  gem "selenium-webdriver", "~> 4.8.1"
  gem "webdrivers", "~> 5.2"
  gem "rspec-rails", "~> 6.0.2"
  gem "factory_bot_rails", "~> 6.2.0"
end

gem 'devise', "~> 4.9"
gem 'responders', "~> 3.1"
gem 'redis', "~> 5.0.6"
gem 'redis-rails', "~> 5.0.2"
gem 'faker', "~> 3.1.1"
gem "noticed", "~> 1.6"
gem 'pagy', "~> 6.0.4"
gem 'cssbundling-rails', "~> 1.1.2"
gem 'omniauth-facebook', "~> 9.0"
gem 'omniauth-google-oauth2', "~> 1.1.1"
gem 'omniauth-rails_csrf_protection', "~> 1.0.1"
gem 'pg_search', "~> 2.3.6"
gem 'aws-sdk-s3', "~> 1.130"