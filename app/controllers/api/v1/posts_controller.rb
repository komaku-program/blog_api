class Api::V1::PostsController < ApplicationController
  def index
    @posts = Post.all
    render json: @posts
  end

  def show
    @post = Post.find(params[:id])
    render json: @post
  end

  def create
    @post = Post.new(post_params.except(:thumbnailUrl))

    @post.thumbnail = params[:thumbnailUrl] if params[:thumbnailUrl].present?

    if @post.save
      render json: @post, status: :created
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  def update
    if @post.update(post_params)
      render json: @post
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
  end

  def archive
    # created_atでソートして月ごとにグループ化
    posts_by_month = Post.all.order(created_at: :desc).group_by { |post| post.created_at.beginning_of_month }

    # 月とその月の投稿数に変換
    archive_data = posts_by_month.map do |month, posts|
      {
        month: month.strftime('%Y年%-m月'),
        post_count: posts.count
      }
    end

    render json: archive_data
  end

  private

  def post_params
    params.require(:post).permit(:title, :content, :thumbnailUrl)
  end
end
