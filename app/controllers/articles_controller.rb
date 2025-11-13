class ArticlesController < ApplicationController
    skip_before_action :verify_authenticity_token
    before_action :set_article, only: [ :show, :update, :destroy ]
    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

    def index
        per_page = (params[:per_page].presence&.to_i || 10).clamp(1, 50)
        @articles = Article.paginate(page: params[:page], per_page: per_page).includes(:user)
        render json: @articles.as_json(
            include: {
                user: { except: [ :password_digest ] }
            }
        )
    end

    def show
        render json: @article
    end

    def create
        @article = Article.new(article_params)
        if @article.save
            render json: @article, status: :created
        else
            render json: { errors: @article.errors.full_messages }, status: :unprocessable_entity
        end
    end

    def update
        if @article.update(article_params)
            render json: @article, status: :ok
        else
            render json: { errors: @article.errors.full_messages }, status: :unprocessable_entity
        end
    end

    def destroy
        @article.destroy
        render json: { message: "Article deleted successfully" }, status: :ok
    end

    private

    def set_article
        @article = Article.find(params[:id])
    end

    def record_not_found
        message = case action_name
        when "update" then "Cannot update: Article not found with id #{params[:id]}"
        when "destroy" then "Cannot delete: Article not found with id #{params[:id]}"
        else "Article not found with id #{params[:id]}"
        end
        render json: { error: message }, status: :not_found
     end

    def article_params
        params.require(:article).permit(:title, :description)
    end
end
