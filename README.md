Elovation
===========================

This supports individual player rankings within multi-player teams, using the [Trueskill ranking system](http://research.microsoft.com/en-us/projects/trueskill/).

Development
---------------------------

 * Edit the ldap.yml and database.yml 

To start the app run:

```
bundle install
rake db:migrate
rails s
```

Production
---------------------------

```
RAILS_ENV=production rails s
```
