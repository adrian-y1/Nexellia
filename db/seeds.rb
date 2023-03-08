# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
FriendRequest.delete_all
Post.delete_all
User.delete_all

adrian = User.create(username: 'adrian', email: 'adrian@adrian', password: 'adrian', password_confirmation: 'adrian')
michael = User.create(username: 'michael', email: 'michael@michael', password: 'michael', password_confirmation: 'michael')
jim = User.create(username: 'jim', email: 'jim@jim', password: 'jimjimjim', password_confirmation: 'jimjimjim')

adrian.posts.create(body: "Lorem ipsum dolor sit amet. Ut molestiae atque ex tempora temporibus qui autem ullam. Et corporis sint ut suscipit corrupti quo numquam autem qui expedita repellendus et atque minima ea minima consectetur")
michael.posts.create(body: "Lorem ipsum dolor sit amet. Eum sint excepturi hic debitis assumenda qui quia adipisci eos eius cupiditate est galisum nemo et consectetur molestiae et sint magni.")
jim.posts.create(body: "Lorem ipsum dolor sit amet. Et nihil dicta sed numquam laboriosam et galisum deleniti.")

adrian.comments.create(body: "Great read!", post_id: adrian.posts.first.id)
michael.comments.create(body: "Cool read!", post_id: michael.posts.first.id)
michael.comments.create(body: "wowww!", post_id: adrian.posts.first.id)
jim.comments.create(body: "Awesome read!", post_id: jim.posts.first.id)

adrian.create_friendship(jim)
# adrian.create_friendship(michael)