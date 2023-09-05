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
    super do
      render json: { message: 'ログアウト成功' } and return
    end
  end
end
