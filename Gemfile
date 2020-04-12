source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.3'

gem 'bootsnap', '>= 1.1.0', require: false
gem 'jbuilder', '~> 2.5'
gem 'mysql2', '>= 0.4.4', '< 0.6.0'
gem 'puma', '~> 3.11'
gem 'rails', '~> 5.2.4', '>= 5.2.4.2'
gem 'sass-rails', '~> 5.0'
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
gem 'uglifier', '>= 1.3.0'
gem 'webpacker'

# ビュー
gem 'enum_help'
gem 'pagy'
gem 'rails-i18n'
gem 'slim-rails'

# 機能
gem 'sorcery'
# api
gem 'faraday'
gem 'faraday_middleware'
gem 'simple_oauth'
gem 'twitter'

group :development, :test do
  gem 'better_errors', '~> 2.6'
  gem 'binding_of_caller', '~> 0.8.0'
  gem 'bullet', '~> 6.1'
  gem 'pry-byebug', '~> 3.9'
  gem 'rails_best_practices', '~> 1.20'
  gem 'rubocop', '~> 0.80.1', require: false
  # RSpec
  gem 'factory_bot_rails', '~> 5.1', '>= 5.1.1'
  gem 'rspec-rails', '~> 3.9', '>= 3.9.1'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console', '>= 3.3.0'
  # gem 'capistrano-rails'
end

group :test do
  gem 'capybara', '~> 3.31'
  gem 'rspec_junit_formatter'
  gem 'shoulda-matchers'
end
