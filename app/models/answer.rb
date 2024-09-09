class Answer < ApplicationRecord
  belongs_to :user
  belongs_to :question
  has_many :likes, as: :likeable, dependent: :destroy

  validates :body, presence: true
  validate_prohibited_words :body
end
