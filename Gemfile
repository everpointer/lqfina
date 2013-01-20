source 'http://ruby.taobao.org'

gem 'rails', '3.2.11'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'mysql2'
# heroku doesn't support sqlite3 but PostgreSQL database => pg
group :production do
  # performance tracking
  gem 'newrelic_rpm'
  gem 'unicorn'
end


# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'

  # gems for twitter-bootstrap-rails
  gem "therubyracer"
  gem "less-rails" #Sprockets (what Rails 3.1 uses for its asset pipeline) supports LESS
  
  # gem 'bootstrap-sass', '~> 2.2.1.1'
  gem "twitter-bootstrap-rails"
end

# bootstrap, dont' put those on group :assets
# which won't required in production, :assets only for realtime compiling
gem 'bootstrap_helper'
gem 'bootstrap-datepicker-rails'

gem 'jquery-rails'

group :test, :development do
    gem 'capistrano'
    gem 'rspec-rails'
    gem 'capybara', '~> 1.1.4'
    # gem 'capybara-webkit'
    gem 'guard-rspec'
    gem 'spork'
    gem 'guard-spork'
    gem 'launchy'
    gem 'factory_girl_rails'
    gem 'database_cleaner'
end

group :development do
  # required by chrome rails-panel extension
  # https://github.com/dejan/rails_panel
  gem 'meta_request', '0.2.0'
end

group :test do
  # make selenium work travis-ci xvfb
  gem "selenium-webdriver", "~> 2.27.2"
end 

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'debugger'

# guard-rspec dependencies
gem 'rb-fsevent', '~> 0.9.1'

# 表单
gem "simple_form"

# paginate
gem "kaminari"
