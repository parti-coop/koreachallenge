source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# ruby '~> 2.4.3'

gem 'rails', '~> 5.2.2'
gem 'unicorn'
gem 'puma', '~> 3.11'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'bundler', '~> 1.17', '>= 1.17.3'
gem 'mysql2', '>= 0.3.13', '< 0.5'
gem 'mini_racer'
gem 'enumerize', '~> 2.3', '>= 2.3.1'
gem 'cocoon'

gem 'jbuilder', '~> 2.5'

# model
gem 'auto_strip_attributes', '~> 2.5'
gem 'kaminari'
gem 'scoped_search', '~> 4.1', '>= 4.1.6'
gem 'by_star'
gem 'roo'

# auth
gem 'devise', '~> 4.5'
gem 'devise-bootstrap-views'
gem 'omniauth'
gem 'omniauth-facebook'
gem 'omniauth-google-oauth2', '~> 0.6.0'
gem 'omniauth-kakao', git: 'git://github.com/johnnyshields/omniauth-kakao'
gem 'omniauth-naver', git: 'git://github.com/parti-coop/omniauth-naver'
gem 'omniauth-twitter'
gem 'pundit'

# file
gem 'carrierwave'
gem 'mini_magick'
gem 'file_validators'

# wordcloud
gem 'twitter-korean-text-ruby', '~> 0.9.2'
gem 'rjb', '~> 1.5', '>= 1.5.9'
gem 'd3-rails'
gem 'd3-cloud-rails'

# view
gem 'bootstrap', '~> 4.3.1'
gem 'jquery-rails', '~> 4.3', '>= 4.3.3'
gem 'haml-rails', '~> 1.0'
gem 'unobtrusive_flash'
# gem 'tinymce-rails', '~> 4.9', '>= 4.9.3'
gem 'tinymce-rails', github: 'parti-coop/tinymce-rails', tag: '5.0.12.0'
gem 'video_info', '~> 2.7'
gem 'browser', '~> 2.6', '>= 2.6.1'

# seo
gem 'meta-tags', '~> 2.11', '>= 2.11.1'

# scheduler
gem 'sidekiq', '~> 4.2', '>= 4.2.10'
gem 'sidekiq-cron', '~> 1.1'
gem 'sidekiq-unique-jobs', '~> 6.0', '>= 6.0.12'
gem 'redis', '~> 3.2', '>= 3.2.2'
gem 'redis-namespace', '~> 1.5', '>= 1.5.2'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

# error
gem 'exception_notification'
gem 'slack-notifier'

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  gem 'chromedriver-helper'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
