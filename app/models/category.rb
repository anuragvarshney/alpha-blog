class Category < ApplicationRecord
    validates :name, presence: true, uniqueness: true, length: { minimum: 2, maximum: 200 }
    has_many :article_categories
    has_many :articles, through: :article_categories
end
