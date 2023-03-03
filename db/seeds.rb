# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
FriendRequest.delete_all
User.delete_all

User.create(username: 'adrian', email: 'adrian@adrian', password: 'adrian', password_confirmation: 'adrian')
User.create(username: 'michael', email: 'michael@michael', password: 'michael', password_confirmation: 'michael')
User.create(username: 'jim', email: 'jim@jim', password: 'jim', password_confirmation: 'jim')