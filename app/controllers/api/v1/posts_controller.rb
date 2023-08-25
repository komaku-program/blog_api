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
    @post = Post.new(post_params)

    # アップロードされた画像の処理
    if params[:image].present?
      uploaded_file = params[:image]
      sanitized_filename = uploaded_file.original_filename.gsub(/\s+/, '_')
      temp_file_path = Rails.root.join("tmp/#{sanitized_filename}")

      File.open(temp_file_path, 'wb') do |file|
        file.write(uploaded_file.read)
      end

      thumbnail_url = generate_thumbnail_url(temp_file_path, sanitized_filename)
      @post.thumbnail_url = thumbnail_url

      File.delete(temp_file_path)
    end

    if @post.save
      render json: @post, status: :created
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
