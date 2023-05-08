# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
FriendRequest.delete_all
Friendship.delete_all
Comment.delete_all
Post.delete_all
Profile.delete_all
Notification.delete_all
Like.delete_all
User.delete_all

dwight = User.create(first_name: 'Dwight', last_name: 'Schrute', email: 'dwight@dwight', password: 'dwight', password_confirmation: 'dwight')
michael = User.create(first_name: 'Michael', last_name: 'Scott', email: 'michael@michael', password: 'michael', password_confirmation: 'michael')
jim = User.create(first_name: 'Jim', last_name: 'Halpert', email: 'jim@jim', password: 'jimjimjim', password_confirmation: 'jimjimjim')
ben = User.create(first_name: 'Ben', last_name: 'Ten', email: 'ben@ben', password: 'benten', password_confirmation: 'benten')
sam = User.create(first_name: 'Sam', last_name: 'Ryder', email: 'sam@sam', password: 'samsam', password_confirmation: 'samsan')
fam = User.create(first_name: 'Fam', last_name: 'Wam', email: 'fam@fam', password: 'famfam', password_confirmation: 'famfam')

dwight.posts.create(body: "Lorem ipsum dolor sit amet. Ut molestiae atque ex tempora temporibus qui autem ullam. Et corporis sint ut suscipit corrupti quo numquam autem qui expedita repellendus et atque minima ea minima consectetur")
michael.posts.create(body: "Lorem ipsum dolor sit amet. Eum sint excepturi hic debitis assumenda qui quia adipisci eos eius cupiditate est galisum nemo et consectetur molestiae et sint magni.")
jim.posts.create(body: "Lorem ipsum dolor sit amet. Et nihil dicta sed numquam laboriosam et galisum deleniti.")

5.times do
  comment = dwight.comments.create(body: "Great read!", commentable: dwight.posts.first)
  comment.comments.create(body: "I agree!", user: dwight, parent: comment, commentable: comment)
end


michael.comments.create(body: "Cool read!", commentable_id: michael.posts.first.id)
michael.comments.create(body: "wowww!", commentable_id: dwight.posts.first.id)
jim.comments.create(body: "Awesome read!", commentable_id: jim.posts.first.id)

dwight.friendships.create(friend: michael)
dwight.friendships.create(friend: ben)
michael.friendships.create(friend: ben)
michael.friendships.create(friend: fam)
