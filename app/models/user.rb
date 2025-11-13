class User < ApplicationRecord
    has_secure_token :auth_token
    enum :role, { user: 0, admin: 1 }
    validates :username, presence: true, uniqueness: { case_sensitive: false }, length: { minimum: 2, maximum: 25 }
    validates :email, presence: true, uniqueness: { case_sensitive: false }, length: { maximum: 105 }, format: { with: URI::MailTo::EMAIL_REGEXP }
    has_many :articles, dependent: :destroy
    before_save { self.email = email.downcase }
    has_secure_password
end
