class Subcategory < ApplicationRecord
  belongs_to :category
  has_many :questions, dependent: :destroy
  has_many :pets, dependent: :destroy

end
