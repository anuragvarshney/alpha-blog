class UsersController < ApplicationController
    before_action :set_user, only: [ :show, :update, :destroy ]
    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def show
    render json: @user.as_json(only: [ :id, :username, :email ])
  end

  def create
    @user = User.new(user_params)
    if @user.save
      render json: @user, status: :created
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def update
    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy
    head :no_content
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def record_not_found
    render json: { error: "User not found" }, status: :not_found
  end

  def user_params
    params.require(:user).permit(:username, :email, :password,)
  end
end
