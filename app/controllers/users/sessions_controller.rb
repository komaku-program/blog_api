class Users::SessionsController < Devise::SessionsController
  respond_to :json

  def create
    Rails.logger.debug '=== HTTP Headers Start ==='
    request.headers.each do |key, value|
      Rails.logger.debug "#{key}: #{value}"
    end
    Rails.logger.debug '=== HTTP Headers End ==='
    super do |_user|
      if user_signed_in?
        render json: { message: 'ログイン成功', user: current_user } and return
      else
        render json: { message: 'ログイン失敗' }, status: :unauthorized and return
      end
    end
  end

  def destroy
    super
  end

  def check_login
    Rails.logger.debug '=== Debugging check_login ==='
    Rails.logger.debug "Request Headers: #{request.headers.inspect}"
    Rails.logger.debug "Current User: #{current_user.inspect}"
    Rails.logger.debug "User Signed In?: #{user_signed_in?}"
    Rails.logger.debug '=== HTTP Headers Start ==='
    request.headers.each do |key, value|
      Rails.logger.debug "#{key}: #{value}"
    end
    Rails.logger.debug '=== HTTP Headers End ==='
    if user_signed_in?
      render json: { loggedIn: true, user: current_user }
    else
      render json: { loggedIn: false } # ここを変更
    end
  end

  private

  def respond_to_on_destroy
    render json: { message: 'ログアウト成功' }
  end
end
