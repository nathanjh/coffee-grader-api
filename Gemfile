source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.0.1'
# Use postgresql as the database for Active Record
gem 'pg', '~> 0.18'
# Use Puma as the app server
gem 'puma', '~> 3.0'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.5'
gem 'active_model_serializers', '~> 0.10.0'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'
# Devise for user auth
gem 'devise'
# Omniauth to use devise_token_auth
gem 'omniauth'
# DeviseTokenAuth for token authentication
gem 'devise_token_auth'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
gem 'rack-cors'

# Use Sidekiq for background processing
gem 'sidekiq'

# To use omniauth with google
gem 'omniauth-google-oauth2'

group :test do
  # adds Codecov for coverage reporting
  gem 'codecov', require: false
  # adds Sidekiq rspec helpers and matchers
  # gem 'rspec-sidekiq'
  gem 'rspec-rails'
  gem 'rails-controller-testing'
  gem 'shoulda-matchers', '~> 3.1', require: false
end

group :development, :test do
  # Manage environment vars in development
  gem 'dotenv-rails'
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
  gem 'factory_girl_rails'
  gem 'faker', git: 'git://github.com/stympy/faker.git', branch: 'master'
  gem 'hirb'
end

group :development do
  gem 'listen', '~> 3.0.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  # To use sidekiq web UI
  gem 'sinatra', github: 'sinatra/sinatra'
end

ruby '2.3.1'

# make things work
gem 'rb-readline'
