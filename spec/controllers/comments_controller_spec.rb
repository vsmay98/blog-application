require 'rails_helper'

RSpec.describe CommentsController do
  let(:user) {FactoryBot.create(:user)}
  let(:admin_user) {FactoryBot.create(:admin)}

  describe '#create' do

    context 'as an authenticated user' do
      before :each do
        session[:user_id] = user.id
        @post = FactoryBot.create(:post, user: user)
      end

      it 'add comment successfully' do
        expect{
          post :create, params: {comment: {comment: 'Vishal'}, post_id: @post.id}
        }.to change(@post.comments, :count).by(1)
      end
    end


    context 'as a guest' do
      it 'redirect to login page' do
        @post = FactoryBot.create(:post)
        post :create, params: {comment: {comment: 'Vishal'}, post_id: @post.id}
        expect(response.status).to eq(302)
        expect(response).to redirect_to(login_path)
      end
    end
  end


  describe '#destroy' do

    context 'as an authenticated user' do
      before :each do
        session[:user_id] = user.id
        @post = FactoryBot.create(:post, user: user)
        @comment = FactoryBot.create(:comment, post: @post, user: user)
      end

      it 'delete comment successfully' do
        expect{
          delete :destroy, params: {id: @comment.id, post_id: @post.id}
        }.to change(@post.comments, :count).by(-1)
      end
    end

    context 'as an admin user' do
      before :each do
        session[:user_id] = admin_user.id
        @post = FactoryBot.create(:post, user: user)
        @comment = FactoryBot.create(:comment, post: @post, user: user)
      end

      it 'delete comment successfully' do
        expect{
          delete :destroy, params: {id: @comment.id, post_id: @post.id}
        }.to change(@post.comments, :count).by(-1)
      end
    end


    context 'as a guest' do
      it 'redirect to login page' do
        @post = FactoryBot.create(:post)
        @comment = FactoryBot.create(:comment, post: @post)
        delete :destroy, params: {id: @comment.id, post_id: @post.id}
        expect(response.status).to eq(302)
        expect(response).to redirect_to(login_path)
      end
    end
  end
end