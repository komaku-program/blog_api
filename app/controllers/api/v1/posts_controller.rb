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
    puts 'こんにちは'
    logger.info 'Create action is called' # 追加
    logger.info "Received thumbnailUrl: #{params[:thumbnailUrl].inspect}"

    @post = Post.new(post_params.except(:thumbnailUrl)) # thumbnailUrl を除いたパラメータで Post を新規作成

    if params[:thumbnailUrl].present? # もし thumbnailUrl が存在していたら
      @post.thumbnail = params[:thumbnailUrl] # thumbnail にセット
      logger.info "Thumbnail has been set: #{@post.thumbnail.inspect}"
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

  def generate_thumbnail_url(temp_file_path, sanitized_filename)
    thumbnail = MiniMagick::Image.open(temp_file_path.path)
    thumbnail.resize '100x100'

    thumbnail_path = Rails.root.join("public/thumbnails/#{sanitized_filename}")
    thumbnail.write thumbnail_path

    "/thumbnails/#{sanitized_filename}"
  end

  def post_params
    params.require(:post).permit(:title, :content, :thumbnailUrl)
  end
end
