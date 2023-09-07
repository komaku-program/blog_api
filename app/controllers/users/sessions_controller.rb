class Users::SessionsController < Devise::SessionsController
  respond_to :json

  def create
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
    if user_signed_in?
      render json: { loggedIn: true, user: current_user, userId: current_user.id }
    else
      render json: { loggedIn: false }
    end
  end

  private

  def respond_to_on_destroy
    render json: { message: 'ログアウト成功' }
  end
end
