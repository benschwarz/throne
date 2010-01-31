# Notes of all the things that the rails implementation should do

# It should look for rails-env
# It should use database.yml
#   It should set the default database to the current environments database
# Database.yml should look like this:
  # environment:
  #   adapter: couchdb
  #   database: resonance_development
  #   username: root
  #   password:
  #   host: 127.0.0.1
  
# It should use activemodel and its magic lint stuff to make it look and feel like something rails might expect

# class User < ActiveModel::Base
#   this shit uses couchdb yo!
# end