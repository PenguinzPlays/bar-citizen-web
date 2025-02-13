module Forum
# app/controllers/posts_controller.rb
class PostsController < ApplicationController
  before_action :set_post_category

  def new
    @post = @post_category.posts.new
    
  end

    def index
      @posts = Post.all
    end
  
    def show
      @post = Post.find(params[:id])

    end
  
  
    def edit
      @post = Post.find(params[:id])
    end
  
    def update
      @post = Post.find(params[:id])
      if @post.update(post_params)
        redirect_to @post, notice: 'Post was successfully updated.'
      else
        render :edit
      end
    end
  
    def destroy
      @post = Post.find(params[:id])
      @post.destroy
      redirect_to posts_url, notice: 'Post was successfully destroyed.'
    end
  

    def create
      @post = @post_category.posts.new(post_params)
      if @post.save
        redirect_to forum_post_category_path(@post_category), notice: 'Post was successfully created.'
      else
        render :new
      end
    end

    private

    def set_post_category
      @post_category = PostCategory.find(params[:post_category_id])
    end

      def post_params
        params.require(:post).permit(:title, :content)
      end
  end
end