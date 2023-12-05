class UsersController < ApplicationController


    def create
        if user_params[:password] != user_params[:password_confirmation]
            render json: { errors: 'Password confirmation does not match' }, status: :unprocessable_entity
          else
            user = User.create(user_params)
            user.password = BCrypt::Password.create(user_params[:password])
            session[:user_id] = user.id
            render json: user, status: :created
          end
end

    def show
        if current_user
            render json: current_user
          else
            render json: { errors: 'User not authenticated' }, status: :unauthorized
          end
    end

    
  private

  def user_params
    params.permit(:username, :password, :password_confirmation)
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

end
