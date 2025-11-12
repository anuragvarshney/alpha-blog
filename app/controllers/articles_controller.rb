class ArticlesController < ApplicationController
    skip_before_action :verify_authenticity_token
    # def show
    #     begin
    #         @article = Article.find(id: params[:id])
    #         render json: @article, status: :ok
    #     rescue ActiveRecord::RecordNotFound
    #       render json: { error: "Article not found" }, status: :not_found
    #     end
    # end

    def index
        @articles = Article.all
        render json: @articles
    end

    def show
        @article = Article.find_by(id: params[:id])
        if @article.nil?
            render json: { error: "Article not found for #{params[:id]}" }
        else
            render json: @article
        end
    end

    def create
        @article = Article.new(article_params)
            if @article.save
                render json: @article, status: :created
            else
                render json: { errors: @article.errors.full_messages }, status: :unprocessable_entity
            end
    end

    private

    def article_params
        params.require(:article).permit(:title, :description)
    end
end
