source 'https://rubygems.org'
ruby '2.3.1'

gem 'rails', '~> 5.0.0', '>= 5.0.0.1'
gem 'pg', '~> 0.18'
gem 'puma', '~> 3.0'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'turbolinks', '~> 5'
gem 'simple_form'
gem 'acts_as_list'
gem 'cocoon'
gem 'ransack'
gem 'kaminari', '~> 0.17.0'
gem 'material_icons'
gem 'countries', '2.0.0.pre.4', require: 'countries/global'
gem 'devise'
gem 'sidekiq'
gem 'sinatra', require: false, git: 'git://github.com/sinatra/sinatra.git'
gem 'rack-protection', require: false, git: 'git://github.com/sinatra/rack-protection.git'

group :development, :test do
  gem 'spring-commands-rspec'
  gem 'rspec-rails', '~> 3.5.0.beta3'
  gem 'factory_girl_rails'
  gem 'faker'
  gem 'pry-rails'
end

group :test do
  gem 'shoulda-matchers', require: false
  gem 'simplecov', require: false
  gem 'capybara', require: false
  gem 'capybara-webkit'
  gem 'database_cleaner', require: false
  gem 'capybara-select2', git: 'git://github.com/goodwill/capybara-select2.git'
end

group :development do
  gem 'listen', '~> 3.0.5'
  gem 'bullet'
  gem 'rails-erd'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
