class Category < ApplicationRecord
    has_many :subcategories, dependent: :destroy
    has_many :questions, through: :subcategories
    has_many :communities
    validates_presence_of :name
end
