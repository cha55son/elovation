Elovation
===========================

![screenshot](http://i.imgur.com/wpGWlsi.png)

This supports individual player rankings within multi-player teams, using the [Trueskill ranking system](http://research.microsoft.com/en-us/projects/trueskill/).

###### Additional features

* LDAP integration
* Bootstrap 3 styling with [bootswatch lumen](https://bootswatch.com/lumen/).
* Motion detection integration (It doesn't do the motion detection but you can setup [linux motion](http://www.lavrsen.dk/foswiki/bin/view/Motion/WebHome) to hit certain routes that trigger the UI change.)
* Given a stream url the app will display a live stream on a game page. (mjpeg and any `<video>` compat. file type)

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
