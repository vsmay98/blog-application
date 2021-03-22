class CommentsController < ApplicationController
	before_action :authorized
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
		if @comment.user == current_user || current_user.admin?
			@comment.destroy
		end
		redirect_to post_path(@post)
	end
end
