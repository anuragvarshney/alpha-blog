require "test_helper"
class CategoriesControllerTest < ActionDispatch::IntegrationTest
    setup do
        @category = Category.create(name: "Sports")
    end

    test "should get index" do
        get categories_url
        assert_response :success
    end

    test "should get new" do
        get new_category_url
        assert_response :success
    end
end
