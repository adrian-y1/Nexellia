FriendRequest.delete_all
Friendship.delete_all
Comment.delete_all
Post.delete_all
Profile.delete_all
Notification.delete_all
Like.delete_all
User.delete_all

p "Seeding: #{__FILE__}"

password = 'password'

dwight = User.create(first_name: 'Dwight', last_name: 'Schrute', email: 'dwight.schrute@nexellia.com', password: password, password_confirmation: password, has_set_password: true)
michael = User.create(first_name: 'Michael', last_name: 'Scott', email: 'michael.scott@nexellia.com', password: password, password_confirmation: password, has_set_password: true)

puts "\nCreating Users...\n"
10.times do |n|
  first_name = Faker::Name.first_name
  last_name = Faker::Name.last_name
  email = "#{first_name.downcase}.#{last_name.downcase}@nexellia.com"
  password = 'password'
  User.create(
    first_name: first_name,
    last_name: last_name,
    email: email,
    password: password,
    password_confirmation: password,
    has_set_password: true
  )
end

puts "\n Creating Posts... \n"
User.all.each do |user|
  user.posts.create(body: Faker::Lorem.paragraph)
  user.posts.create(body: Faker::Lorem.paragraph)
end

puts "\n Creating Comments... \n"
4.times do
  dwight.comments.create(body: Faker::Lorem.paragraph, commentable: dwight.posts.last)
end

puts "\n Creating Replies... \n"
dwight.comments.each do |comment|
  comment.comments.create(body: Faker::Lorem.paragraph, user: dwight, parent: comment, commentable: dwight.posts.last)
end
5.times do
  dwight.comments.last.comments.create(body: Faker::Lorem.paragraph, user: dwight, parent: dwight.comments.last, commentable: dwight.posts.last)
end

puts "\n Creating Friendships... \n"
dwight.friendships.create(friend: michael)
dwight.friendships.create(friend: User.last)

# Loop through the users and create a friendship between each user and a random other user
for i in 0..(5 - 1) do
  user_1 = User.all.sample
  user_2 = User.all.sample
  user_1.friendships.create(friend: user_2)
end

puts "\n Creating Likes... \n"
User.limit(5).each do |user|
  user.like(dwight.posts.last)
end
