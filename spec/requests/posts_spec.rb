require 'rails_helper'

RSpec.describe "Posts", type: :request do
  let(:user1) { create(:user) }
  let(:user2) { create(:user) }
  let(:user3) { create(:user) }

  before do
    sign_in(user1)
    user1.create_friendship(user2)
  end

  describe "GET /index" do
    before do
      create(:post, user: user1)
      create(:post, user: user2)
    end

    it "returns a status of 200 ok" do
      get posts_path
      expect(response).to have_http_status(200)
    end

    it "returns user and friends' posts" do
      get posts_path
      user_and_friends_posts = Post.user_and_friends_posts(user1)
      expected_post_bodies = user_and_friends_posts.map(&:body)
      expect(response.body).to include(*expected_post_bodies)
    end
  end

  describe "GET /new" do
    it "returns a status of 200 ok" do
      get new_post_path
      expect(response).to have_http_status(200)
    end

    it "displays the form for creating a new post" do
      get new_post_path
      expect(response.body).to include("Create Post")
      expect(response.body).to include("body")
    end
  end

  describe "GET /show" do
    it "returns a status of 200 ok" do
      post = create(:post, user: user1)
      get post_path(post)
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /edit" do
    it "returns a status of 200 ok" do
      post = create(:post, user: user1)
      get edit_post_path(post)
      expect(response).to have_http_status(200)
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Post" do
        expect {
          post posts_path, params: { post: { body: "Testing!" } }
        }.to change(Post, :count).by(1)
      end
    end

    context "with invalid parameters" do
      it "doesnt create a new Post" do
        expect {
          post posts_path, params: { post: { body: nil } }
        }.to change(Post, :count).by(0)
      end
    end
  end 

  describe "PATCH /update" do
    context "with valid parameters" do
      it "updates the requested post" do
        post = create(:post, user: user1)
        updated_post = "Updated post"
        patch post_path(post), params: { post: { body: updated_post } }
        expect(post.reload.body).to eq(updated_post)
      end

      it "redirects after post creation with status code 302" do
        post = create(:post, user: user1)
        patch post_path(post), params: { post: { body: "Updated post again" } }
        post.reload
        expect(response).to have_http_status(302)
      end
    end

    context "with invalid parameters" do
      it "returns a status of 303 see other" do
        post = create(:post, user: user1)
        patch post_path(post), params: { post: { body: nil } }
        post.reload
        expect(response).to have_http_status(303)
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested post" do
      post = create(:post, user: user1)
      expect { delete post_path(post) }.to change(Post, :count).by(-1)
    end
  end
end
