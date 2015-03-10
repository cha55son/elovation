source 'https://rubygems.org'

gem 'rails', '~> 4.1.7'

gem 'sqlite3'

gem 'sass-rails', '~> 4.0.3'
gem 'jquery-rails'
gem 'coffee-rails'
gem 'uglifier'

gem 'dynamic_form'
gem 'elo'
gem 'trueskill', github: 'saulabs/trueskill', require: 'saulabs/trueskill'

group :production do
  gem 'unicorn'
end

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'quiet_assets'
end

group :development, :test do
  gem 'factory_girl_rails'
  gem 'faker'
  gem 'pry'
  gem 'pry-byebug'
  gem 'pry-coolline'
  gem 'pry-rails'
  gem 'pry-stack_explorer'
  gem 'spring'
  gem 'spring-commands-rspec'
end

group :test do
  gem 'mocha'
  gem 'rspec-rails', '~> 2.14.2'
  gem 'timecop'
end
