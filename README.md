<div style="display:flex; align-items: center; gap: 10px;">
  <img src="app/assets/images/nexellia.png" width="60">
  <div style="font-size: 35px;"> <b>Nexellia</b> </div>
</div>
<hr>

Live Site: [nexellia.onrender.com](https://nexellia.onrender.com/)


## Overview
Nexellia is a full-featured social media platform, developed using `Ruby on Rails 7`, that serves as a Facebook clone application. It offers users the ability to create posts, interact with other users' posts, and establish connections with other users, among many other functionalities.

One of the key strengths of Nexellia lies in its efficient use of the `Hotwire/Turbo` library, which empowers the platform to deliver real-time updates to users. These updates encompass a range of features, including posts, likes, comments, notifications, and more, providing users with a dynamic and engaging social media experience.


## Demo
<img alt="Nexellia demo" src="demo/nexellia_demo.gif"><br>
*Nexellia demonstration*


## Table of Contents
- [Dependencies](https://github.com/adrian-y1/Nexellia#dependencies)
- [Initial Setup](https://github.com/adrian-y1/Nexellia#initial-setup)
- [Developing Locally](https://github.com/adrian-y1/Nexellia#developing-locally)
- [Running Tests](https://github.com/adrian-y1/Nexellia#running-tests)
- [Deployment](https://github.com/adrian-y1/Nexellia#deployment)
- [Features](https://github.com/adrian-y1/Nexellia#features)
- [Challenges Faced](https://github.com/adrian-y1/Nexellia#challenges-faced)
- [Future Plans](https://github.com/adrian-y1/Nexellia#future-plans)
- [Conclusion](https://github.com/adrian-y1/Nexellia#conclusion)
- [Attributions](https://github.com/adrian-y1/Nexellia#attributions)

## Dependencies
- `rails 7.0.4.2`
- `ruby 3.1.2`
- `node 16.16.0`
- `yarn 1.22.19`
- `postgresql 14.8`
- `redis 6.0.16`
- `libvips`


## Initial Setup
- Clone Repo
  - SSH: `git clone git@github.com:adrian-y1/Nexellia.git`
  - HTTPS: `git clone https://github.com/adrian-y1/Nexellia.git`
- `cd` into the project directory
- Run `bundle install`
- Run `rails db:setup`
- Run `yarn install`


## Developing Locally
To start the development server, along with `sass`, run:
- `./bin/dev`


## Running Tests
- To run all tests: `bundle exec rspec`
- To run a specific file or folder: `bundle exec rspec spec/path/to/file`


## Deployment
- Render: [render.com](https://render.com/)
- AWS S3: [aws.amazon.com/s3](https://aws.amazon.com/s3/)
- SMTP: [guides.rubyonrails.org](https://guides.rubyonrails.org/action_mailer_basics.html#action-mailer-configuration-for-gmail)


## Features
### Authentication
  - Login
  - Register
  - Forgot Password
  - Google Sign in/Sign up
  - Welcome Email
  - Edit Account

### Posts
Updates for posts are instantly reflected in real-time.
  - Create
  - Update
  - Delete
  - Upload Image
  - Infinite Scroll

### Comments
Updates for comments are instantly reflected in real-time.
  - Create
  - Delete
  - Replies

### Likes
Updates for likes are instantly reflected in real-time.
  - Like/Unlike Comments & Replies
  - Like/Unlike Posts

### Friend Requests
Updates for friend requests are instantly reflected in real-time.
  - Send Friend Request
  - Cancel Friend Request
  - Accept/Decline Friend Request
  - Remove Friend

### Notifications
Updates for notifications are instantly reflected in real-time.
  - Create Comment or Reply Notification
  - Like Post or Comment Notification
  - Send Friend Request Notification
  - Accept Friend Request Notification
  - Mark all as read
  - Clear all (deletes all)

### Profile
  - Edit Profile
  - Upload Cover Photo and Profile Picture
  - Bio
  - Friends
  - Search Friends

### Other Features
  - Search Users (using AJAX)
  - Dark and Light mode
  - User Online Status (online/offline/last-online-at)
  - Fully Responsive


## Challenges Faced
### Hotwire/Turbo
The most challenging aspect of developing this web application was implementing real-time features using the `Hotwire/Turbo` library. Understanding how `broadcasting`, `turbo-streams`, and `turbo-frames` worked was very challenging and took a significant amount of time. The limited availability of online resources for this relatively less popular library made overcoming obstacles even more difficult. One particular issue was figuring out how to get the `current_user` in the `turbo-streams` partials to display actions such as `edit` or `delete` only to the authors for the likes of a `post` or `comment`. Since `turbo-streams` doesn't render the partials within the context of a `request` and throws a `Warden::Proxy error`, accessing `current_user` directly was problematic.

To address this challenge, I utilized the `ActiveSupport::CurrentAttributes` super class. This approach ensured that the currently logged-in user was passed to the `turbo-streams` partials, enabling me to check if they had the authority to perform specific actions if they were the authors. However, even with the usage of `ActiveSupport::CurrentAttributes`, the issue persisted, necessitating additional problem-solving. As a workaround, I employed `inline styling` to display the correct buttons exclusively for the author, and resolving the issue.


### ActiveStorage
Another challenging issue I encountered during the development process was related to `ActiveStorage` and involved adding a profile picture for users. When a user attempted to `update` their profile picture but faced a validation failure from another field, it resulted in an unexpected `ActiveStorage::FileNotFoundError`. This error occurred because `ActiveStorage` could not find a file associated with the attached file record. Despite spending days on research and conducting trial and error, I identified that the bug only occurred for the default image provided to users upon signing up. This happened because the default image was not stored in the database using `ActiveStorage`, leading to the `ActiveStorage::FileNotFoundError`. Additionally, the issue was caused by the default image passing the `.attached?` and `.representation?` checks.

To address this issue, I implemented `Gravatar` as an alternative approach for adding default images for users. Instead of saving a file, `Gravatar` provides a `web URL` for the image. By incorporating a `begin & rescue` block, I ensured that if the `ActiveStorage::FileNotFoundError` occurs, it defaults to the Gravatar URL for that user. In the controller, I stored the user's profile picture in a variable so that it could be `reattached` if the profile object failed to be updated. This solution effectively resolved the `ActiveStorage` issue related to profile pictures and ensured a smoother user experience when updating their profile information.


## Future Plans
In the future, I am enthusiastic about continuously enhancing this application by incorporating additional features to elevate its performance and user experience. Some of the exciting features I look forward to implementing include:
  - Messenger (Real-time chat)
  - Save posts & Notification for it
  - A Friend's Post Notifications
  - Comment reply indicators
  - Edit comments
  - Photos in comments
  - Confirmation modal for deleting comments and posts
  - User profile display on hover
  - Post Private/Public setting
  - Videos in posts
  - Links in posts
  - Reactions (Emojis)


## Conclusion
Nexellia is a feature-rich social media platform developed using `Ruby on Rails 7`, providing users with a seamless experience to create, interact with, and connect through various functionalities, inspired by Facebook. The implementation of real-time features using the `Hotwire/Turbo` library presented notable challenges, requiring extensive understanding of `broadcasting`, `turbo-streams`, and `turbo-frames`. Despite limited online resources, I persevered through trial and error, to solve the problems i came across. 

Through these challenges, i was able to enahnce my technical skills but the development process also taught me to creatively solve problems and leverage existing tools like `Gravatar` for improved user interactions. As Nexellia continues to evolve, I look forward to implementing future features such as real-time chat, enhanced comment & post functionalities, and more.


## Attributions
- `libvips` library for images: [github.com./libvips](https://github.com/libvips/libvips)
- `Gravatar` for default image: [en.gravatar.com](https://en.gravatar.com/)
- `default.png` for testing purposes: Icon PNG by [Vecteezy](https://www.vecteezy.com/free-png/profile-icon)
- `avatar1.png` for testing purposes: Icon by [Fayethequeen93](https://www.dreamstime.com/fayethequeen93_info) on [Dreamstime](https://www.dreamstime.com/stock-illustration-male-avatar-icon-flat-style-male-user-icon-cartoon-man-avatar-hipster-vector-stock-image91462914)
- `avatar2.png` for testing purposes: Icon PNG by [Vecteezy](https://www.vecteezy.com/free-vector/user-icon)
- `google icon svg` - By Google Inc. - google.com Google icon-Sep15 Google &quot;G&quot; Logo, Public Domain, [commons.wikimedia.org](https://commons.wikimedia.org/w/index.php?curid=42850884)