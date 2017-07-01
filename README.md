# logger
Daily Recap manager

How to run the app locally?

Dependencies

Install ruby 2.3.1 using the following command rvm install 2.3.1
Install mysql locally using homebrew
gem install bundler # Installs bundler 
bundle install # Installs the gems

bundle exec rake db:create # To create the database 

bundle exec rake db:migrate # To run the migrations

bundle exec rake db:seed #to run the seed file.

bundle exec rails s # Start the rails server.


Open 'http://localhost:3000' in your browser.
