class ApplicationController < ActionController::API
    include ActionController::HttpAuthentication::Token::ControllerMethods

    before_action :authenticate

    def require_admin
        render json: { error: "Admin privileges required" }, status: :forbidden unless current_user&.admin?
    end

    def required_admin_or_self(user)
        render json: { error: "Admin privileges or ownership required" }, status: :forbidden unless current_user&.admin? || current_user == user
    end

    private

    def authenticate
        authenticate_or_request_with_http_token do |token, options|
            @current_user = User.find_by(auth_token: token)
        end
    end

    def current_user
        @current_user
    end
end
