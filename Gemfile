source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.4.9'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem "rails", "~> 8.1.0"

# Use SQLite as the database for Active Record
gem "sqlite3", ">= 2.1"

# Solid adapters for cache, queue, and cable (SQLite-backed)
gem "solid_queue"
gem "solid_cache"
gem "solid_cable"
# Use Puma as the app server
gem 'puma'
# Use SCSS for stylesheets
gem 'sass-rails'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder'

gem 'devise'

# Use Redis adapter to run Action Cable in production
# gem 'redis', '
# Use Active Model has_secure_password
# gem 'bcrypt'

# Use Active Storage variant
# gem 'image_processing'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', require: false

gem "kamal", require: false
gem "thruster", require: false

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'rmagick'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console'
  gem 'listen'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen'
  gem 'guard'
  gem 'guard-livereload'
  # Procfile runner for development
  gem 'foreman'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara'
  gem 'selenium-webdriver'
  # Easy installation and use of web drivers to run system tests with browsers
  gem 'webdrivers'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

gem 'psych'
gem "csv"

gem "jsbundling-rails", "~> 1.3"
gem "cssbundling-rails", "~> 1.4"

gem "stimulus-rails", "~> 1.3"
