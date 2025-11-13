class AuthenticationController < ApplicationController
    skip_before_action :authenticate, only: [ :login, :signup ]

    def login
        user = User.find_by(email: params[:email])
        if user&.authenticate(params[:password])
            render json: { auth_token: user.auth_token, user: user }, status: :ok
        else
            render json: { error: "Invalid email or password" }, status: :unauthorized
        end
    end

    def logout
        if current_user
            current_user.regenerate_auth_token
            render json: { message: "Logged out successfully" }, status: :ok
        else
            render json: { error: "Invalid token" }, status: :unauthorized
        end
    end

    def signup
        user = User.new(user_params)
        if user.save
            render json: { auth_token: user.auth_token, user: user }, status: :created
        else
            render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
        end
    end

    private

    def user_params
        params.permit(:username, :email, :password, :password_confirmation)
    end
end
