class CategoriesController < ApplicationController
    before_action :set_category, only: [ :show, :update, :destroy ]
    before_action :require_admin, only: [ :index, :create, :update ]

    def index
        @categories = Category.all
        render json: @categories, status: :ok
    end

    def show
        render json: @category, status: :ok
    end

    def create
        @category = Category.new(category_params)
        if @category.save
            render json: { message: "Category created successfully" }, status: :created
        else
            render json: { errors: @category.errors.full_messages }, status: :unprocessable_entity
        end
    end

    def update
        if @category.update(category_params)
            render json: { message: "Category updated successfully" }, status: :ok
        else
            render json: { errors: @category.errors.full_messages }, status: :unprocessable_entity
        end
    end

    def destroy
        @category.destroy
        render json: { message: "Category deleted successfully" }, status: :ok
    end

    private

    def set_category
        @category = Category.find(params[:id])
    end

    def category_params
        params.require(:category).permit(:name)
    end
end
