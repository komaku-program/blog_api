class Api::V1::UploadsController < ApplicationController
  def create
    uploaded_file = params[:image]

    if uploaded_file
      sanitized_filename = uploaded_file.original_filename.gsub(/\s+/, '_')
      temp_file_path = Rails.root.join('tmp', 'uploads', sanitized_filename)

      File.open(temp_file_path, 'wb') do |file|
        file.write(uploaded_file.read)
      end

      thumbnail_url = generate_thumbnail_url(temp_file_path, sanitized_filename)

      File.delete(temp_file_path)

      render json: { thumbnailUrl: thumbnail_url }
    else
      render json: { error: 'No image uploaded' }, status: :unprocessable_entity
    end
  end

  private

  def generate_thumbnail_url(temp_file_path, sanitized_filename)
    thumbnail = MiniMagick::Image.open(temp_file_path)
    thumbnail.resize '500x500'

    thumbnail_dir = Rails.root.join('public/thumbnails')

    thumbnail_path = thumbnail_dir.join(sanitized_filename)
    thumbnail.write thumbnail_path.to_s

    "/thumbnails/#{sanitized_filename}"
  end
end
