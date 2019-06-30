source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.3'

gem 'aws-sdk-s3', '~> 1.14'
gem 'bootsnap', '>= 1.1.0', require: false
gem 'devise'
gem 'image_processing', '~> 1.0'
gem 'mini_magick', '~> 4.0'
gem 'puma', '~> 3.11'
gem 'rails', '~> 5.2.3'
gem 'shrine', '~> 2.0'
gem 'sidekiq'
gem 'sidekiq-failures', '~> 1.0'
gem 'sidekiq-status'
gem 'simple_token_authentication', '~> 1.0'
gem 'sqlite3'

group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'dotenv-rails'
  gem 'rubocop', require: false
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
