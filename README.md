#Enrolment Planner
=============

Enrolment Planner for a Uni

###Software/programs required to run the application:
1. Ruby + Rails framework

2. MySQL database

###Development environment setup:

1. Setup the Database connection to match config/database.yml.

2. Run "gem bundle install" to install required gem for the appication.

3. Run "bundle exec rake db:create" to setup the required Database in DB server.

4. Run "bundle exec rake db:migrate" to set up the DB structure (tables) defined in .application

###To run the application:

1. Run "rails server" to start application server.

2. In your web browser, natvigate to "localhost:3000" and it redirects to the planner page.