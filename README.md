#Enrolment Planner
--------------

Enrolment Planner for Computing courses in Curtin University

###Software/programs required to run the application:
1. Ruby + Rails framework

2. MySQL database

###Development environment setup:
If this is your first time to run the application, follow the steps below to setup the application environment:

1. Setup the Database (username, password, etc.) to match config/database.yml.

2. Run "gem bundle install" to install missing required gem for the appication.

3. Run "bundle exec rake db:create" to create the required Database in DB server.

4. Run "bundle exec rake db:migrate" to load in the DB structure (tables) as defined in db/schema.rb

If the database schema has been changed in a commit, it is recommended to drop the tables that you currently have first, then do the create as well as migrate commands again to make sure that your database isat the "initial state".

###To run the application:

1. Run "rails server" to start up application server.

2. In your web browser, natvigate to "localhost:3000" and it redirects to the planner page.