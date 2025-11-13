class Category < ApplicationRecord
    validates :name, presence: true, uniqueness: true, length: { minimum: 2, maximum: 200 }
end
