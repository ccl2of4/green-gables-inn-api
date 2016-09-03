# Green Gables Inn API

[![Build Status](https://travis-ci.org/ccl2of4/green-gables-inn-api.png)](https://travis-ci.org/ccl2of4/green-gables-inn)

## Initial Setup

* Install PostgreSQL, enable any necessary system services, and add yourself as a user
  - `createuser --interactive`
* Install `rails`
  - `gem install rails`
* Install the dependencies for the application
  - `bundle install --path vendor/bundle`
* Create the database
  - `rake db:create`
* Create tables/migrate database to the current schema
  - `rake db:migrate`

## Run Tests

* `rails test`

## Run Server

* `rails server`
*

## HTTP Basic Auth

This application uses HTTP Basic Auth to secure protected resources. The environment variables $USERNAME and $PASSWORD are used to define a global username and password for those resources. In non-production environments, if they are left unset they will default to "username" and "password" respectively.
