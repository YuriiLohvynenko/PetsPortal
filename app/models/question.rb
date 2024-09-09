class Question < ApplicationRecord
  belongs_to :user
  has_many :answers, dependent: :destroy
  belongs_to :subcategory
  has_one :category, through: :subcategory
  validate_prohibited_words :body
  validates_presence_of :body, :subcategory_id

  def self.search(category, subcategory, status, special_category, free_words)
    questions = self.all
    category_object = Category.find_by(id: category) if category.present?
    questions = questions.joins(:subcategory).where(subcategories: { category_id: category_object.id }) if category_object.present?
    questions = questions.where(subcategory_id: subcategory) if subcategory.present?
    questions = questions.where("body ILIKE ?", "%#{free_words}%") if free_words.present?
    questions = questions.where(special_category: special_category) if special_category.present?
    questions = questions.where(status: status) if status.present?
    questions
  end

  def answered_by?(user)
    answers.where(user: user).exists?
  end
end
