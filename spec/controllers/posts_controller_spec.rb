require 'rails_helper'

RSpec.describe PostsController do

  let(:user) {FactoryBot.create(:user)}
  let(:admin_user) {FactoryBot.create(:admin)}

  describe '#index' do
    context "as an authenticated user" do
      before :each do
        session[:user_id] = user.id
      end

      it "responds successfully" do
        get :index
        expect(response).to be_success
      end
    end

    context "as an guest" do

      it "responds successfully" do
        get :index
        expect(response).to be_success
      end
    end
  end


  describe '#create' do
    context "as an authenticated user" do
      before :each do
        session[:user_id] = user.id
      end

      it "responds successfully" do
        expect{
          post :create, params: {post: {title: 'first post', content: 'post content'}}
        }.to change(user.posts, :count).by(1)
      end
    end

    context "as an guest" do

      it "redirect to login page" do
        post :create, params: {post: {title: 'first post', content: 'post content'}}
        expect(response.status).to eq(302)
        expect(response).to redirect_to(login_path)
      end
    end
  end

  describe '#destroy' do
    context "as an authenticated user" do
      before :each do
        session[:user_id] = user.id
        @post = FactoryBot.create(:post, user_id: user.id)

      end

      it "responds successfully" do
        expect{delete :destroy, params: {id: @post.id}
        }.to change(user.posts, :count).by(-1)
      end
    end

    context "as an admin user" do
      before :each do
        session[:user_id] = admin_user.id
        @post = FactoryBot.create(:post, user_id: user.id)
      end

      it "responds successfully" do
        expect{delete :destroy, params: {id: @post.id}
        }.to change(user.posts, :count).by(-1)
      end
    end

    context "as an guest" do

      it "redirect to login page" do
        @post = FactoryBot.create(:post)
        delete :destroy, params: {id: @post.id}
        expect(response.status).to eq(302)
        expect(response).to redirect_to(login_path)
      end
    end
  end


  describe '#update' do
    context "as an authenticated user" do
      before :each do
        session[:user_id] = user.id
        @post = FactoryBot.create(:post, user_id: user.id)
      end

      it "update successfully" do
        new_params = FactoryBot.attributes_for(:post, title: "New title")
        patch :update, params: {id: @post.id, post: new_params}
        expect(@post.reload.title).to eq "New title"
      end
    end

    context "as an admin user" do
      before :each do
        session[:user_id] = admin_user.id
        @post = FactoryBot.create(:post, user_id: user.id)
      end

      it "update successfully" do
        new_params = FactoryBot.attributes_for(:post, title: "New title")
        patch :update, params: {id: @post.id, post: new_params}
        expect(@post.reload.title).to eq "New title"
      end
    end

    context "as an guest" do

      it "redirect to login page" do
        @post = FactoryBot.create(:post)
        new_params = FactoryBot.attributes_for(:post, title: "New title")
        patch :update, params: {id: @post.id, post: new_params}
        expect(response.status).to eq(302)
        expect(response).to redirect_to(login_path)
      end
    end
  end
end