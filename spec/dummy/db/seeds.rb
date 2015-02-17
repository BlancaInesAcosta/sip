# encoding: UTF-8
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


connection = ActiveRecord::Base.connection();

connection.execute(IO.read("../../db/datos-basicas.sql"));

connection.execute("INSERT INTO usuario 
  (nusuario, email, encrypted_password, password, 
  fechacreacion, created_at, updated_at, rol) 
  VALUES ('sip', 'sip@localhost', 
  '$2a$10$V2zgaN1ED44UyLy0ubey/.1erdjHYJusmPZnXLyIaHUpJKIATC1nG', 
  '', '2014-08-26', '2014-08-26', '2014-08-26', 1);")



