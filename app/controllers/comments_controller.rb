class CommentsController < ApplicationController
	before_action :authorized
	before_action :can_access_comment?, only: [:destroy]
	def create
		@post = Post.find(params[:post_id])
	 	@comment = @post.comments.new(params[:comment].permit(:comment))
	 	@comment.user = current_user
	 	@comment.save
		redirect_to post_path(@post)
	end

	def destroy
		@post = Post.find(params[:post_id])
		@comment = @post.comments.find(params[:id])
		@comment.destroy
		redirect_to post_path(@post)
	end

	private

	def can_access_comment?
		@comment = Comment.find(params[:id])
		redirect_to root_path, alert: 'You may not access comment.' unless (@comment.user == current_user || current_user.admin?)
	end
end
