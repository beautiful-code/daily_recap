# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

source 'https://rails-assets.org' do
  gem 'rails-assets-tether', '>= 1.3.3'
end

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'bootstrap', '~> 4.0.0.alpha6'
gem 'dotenv-rails'
gem 'execjs'
gem 'haml'
gem 'jquery-rails'
gem 'mysql2'
gem 'rails', '~> 5.1.1'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem "omniauth-google-oauth2", "~> 0.2.1"
gem 'wicked'
gem "factory_girl_rails", "~> 4.0"
gem "cocoon"
group :development, :test do
  gem 'byebug'
  gem 'capybara', '~> 2.13'
  gem 'puma', '~> 3.7'
  gem 'rspec-rails'
  gem 'rubocop'
  gem 'selenium-webdriver'
  gem 'shoulda-matchers'
  gem 'simplecov'
end

group :development do
  gem 'html2haml'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console', '>= 3.3.0'
end
