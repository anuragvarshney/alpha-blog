class ArticlesController < ApplicationController
    
    # def show
    #     begin
    #         @article = Article.find(id: params[:id])
    #         render json: @article, status: :ok
    #     rescue ActiveRecord::RecordNotFound
    #       render json: { error: "Article not found" }, status: :not_found
    #     end
    # end

    def show
            @article = Article.find_by(id: params[:id])
            if @article.nil?
                render json: { error: "Article not found for #{params[:id]}" }
            else
                render json: @article
            end
        end
end
