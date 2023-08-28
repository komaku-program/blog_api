class Api::V1::PostsController < ApplicationController
  def index
    @posts = Post.all
    render json: @posts
  end

  def show
    @post = Post.find(params[:id])
    render json: @post
  end

  # create アクションで thumbnailUrl を thumbnail にマッピング
  def create
    @post = Post.new(post_params.except(:thumbnailUrl)) # thumbnailUrl を除いたパラメータで Post を新規作成

    if params[:thumbnailUrl].present? # もし thumbnailUrl が存在していたら
      @post.thumbnail = params[:thumbnailUrl] # thumbnail にセット
    end

    if @post.save # 保存処理
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

  private

  def post_params
    params.require(:post).permit(:title, :content, :thumbnailUrl)
  end
end
