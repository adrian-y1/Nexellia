p "Seeding: #{__FILE__}"

password = 'password'

if User.count < 10
  puts "\nCreating Users...\n"
  random_users = []
  10.times do |n|
    first_name = Faker::Name.first_name
    last_name = Faker::Name.last_name
    email = "#{first_name.downcase}.#{last_name.downcase}@nexellia.com"
    password = 'password'
    random_user = User.create(
        first_name: first_name,
        last_name: last_name,
        email: email,
        password: password,
        password_confirmation: password
      )
      random_users << random_user
  end

  puts "\n Adding public_email... \n"
  random_users.each do |random_user|
    random_user.profile.update(public_email: random_user.email, bio_description: "My password is password and my email is above.")
  end

  puts "\n Creating Posts... \n"
  random_users.each do |random_user|
    user.posts.create(body: Faker::Lorem.paragraph)
    user.posts.create(body: Faker::Lorem.paragraph)
  end

  puts "\n Creating Comments... \n"
  4.times do
    random_users.sample.comments.create(body: Faker::Lorem.paragraph, commentable: User.first.posts.first)
  end

  puts "\n Creating Friendships... \n"
  # Loop through the users and create a friendship between each user and a random other user
  for i in 0..(5 - 1) do
    user_1 = random_users.sample
    user_2 = random_users.sample
    user_1.friendships.create(friend: user_2)
  end
end
