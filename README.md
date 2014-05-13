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

3. Run "bundle exec rake db:create db:migrate" to create and migrate required Database and tables onto DB server.

4. Run "bundle exec rake routes" to create route resources required in web application.

Ps1. If the database schema has been changed in a commit, run "bundle exec rake db:drop" to drop current DB, then run command in step 3 again. It is to make sure that the database structure is in initial state.

Ps2. If you wish the test the application with test data, run "bundle exec rake db:seed" to add data defined in db/seed.rb. However, if you are going to test "Admin import/export" functions, please go through step Ps1 to test in initial state environment.

###To run the application:

1. Run "rails server" to start up application server.

2. In your web browser, natvigate to "localhost:3000" and it redirects to the planner page.