class UsersController < ApplicationController
    before_action :set_user, only: [ :show, :update, :destroy ]
    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

    # this is the old index method without articles included this has n+1 query problem
    # n+1 query problem occurs when an application needs to load related data for multiple records, resulting in one query to fetch the main records and additional queries for each related record.
    # example: if we have 10 users and each user has articles, the old index method would execute 1 query to fetch all users and then 10 additional queries (one for each user) to fetch their articles, resulting in a total of 11 queries.
    # to solve this n+1 query problem we use includes method to eager load the articles along with users in a single query.
    # def index
    #   @users = User.all
    #   render json: @users.as_json(
    #     except: [ :password_digest ],
    #     # include: :articles
    #     # include: {articles:{ only: [:title]}}
    #   )
    # end


    # updated index method to include articles and avoid n+1 query problem
    # here we use includes(:articles) to eager load articles associated with users, reducing the number of database queries and improving performance.
    # this way, when we access the articles for each user, they are already loaded in memory, avoiding additional queries.
    # this is especially beneficial when dealing with a large number of users and their associated articles.
    # example : with includes, fetching 10 users and their articles would typically result in just 2 queries: one for the users and one for all their articles, significantly reducing the total number of queries executed.
    def index
      per_page = (params[:per_page].presence&.to_i || 10).clamp(1, 50)
      @users = User.includes(:articles).paginate(page: params[:page], per_page: per_page)
      render json: @users.as_json(
        except: [ :password_digest ],
        include: :articles
        # include: { articles: { only: [ :title ] } }
      )
    end

    def show
      render json: @user.as_json(only: [ :id, :username, :email ])
    end

    # def create
    #   @user = User.new(user_params)
    #   if @user.save
    #     render json: @user, status: :created
    #   else
    #     render json: @user.errors, status: :unprocessable_entity
    #   end
    # end

    def update
      if @user.update(user_params)
        render json: @user
      else
        render json: @user.errors, status: :unprocessable_entity
      end
    end

    def destroy
      @user.destroy
      @current_user = nil
      render json: { message: "User deleted successfully" }, status: :ok
    end

    private

    def set_user
      @user = User.find(params[:id])
    end

    def record_not_found
      render json: { error: "User not found" }, status: :not_found
    end

    def user_params
      params.require(:user).permit(:username, :email)
    end
end
