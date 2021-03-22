class PostsController < ApplicationController
	 # before_action :find_post, only: [:show, :update, :edit, :destroy]
	 before_action :authorized, except: [:index, :show]
	def index
		@posts = Post.all.order("created_at DESC")
	end

	def new
		@post = Post.new
	end

	def create
		@post = Post.new(post_params)
		@post.user = current_user
		if @post.save
			redirect_to @post
		else
			render 'new'
		end
	end

	def show
		@post = Post.find(params[:id])
	end

	def update

		if (@post.user == current_user || current_user.admin?) && @post.update(post_params)
			redirect_to @post
		else
			render 'edit'
		end
	end

	def edit
		@post = Post.find(params[:id])
	end

	def destroy
		@post = Post.find(params[:id])
		if @post.user == current_user || current_user.admin?
			@post.destroy
		end

		redirect_to posts_path

	end

	private

	def post_params
		params.require(:post).permit(:title, :content)
	end

	# def find_post
	# 	@post = Post.find(params[:id])
	# end

end
