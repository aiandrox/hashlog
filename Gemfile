source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.6'

gem 'bootsnap', '>= 1.1.0', require: false
gem 'mysql2', '>= 0.4.4', '< 0.6.0'
gem 'puma', '~> 3.12'
gem 'rails', '~> 5.2.4', '>= 5.2.4.3'
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
gem 'webpacker'

# 日本語化
gem 'enum_help'
gem 'rails-i18n'
# 機能
gem 'active_model_serializers', '~> 0.10.0'
gem 'banken'
gem 'config'
gem 'pagy', '~> 3.5'
gem 'sorcery', '>= 0.15.0'
# 定期実行
gem 'redis-namespace'
gem 'sidekiq', '~> 5.0'
gem 'whenever', require: false
# 外部API
gem 'twitter'

group :development, :test do
  gem 'bullet', '~> 6.1'
  gem 'pry-byebug', '~> 3.9'
  gem 'pry-rails'
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
  # gem 'capistrano-rails', require: false
end

group :test do
  gem 'capybara', '~> 3.31'
  gem 'rspec_junit_formatter'
  gem 'shoulda-matchers'
  # モック
  gem 'vcr', require: false
  gem 'webmock', require: false
end
