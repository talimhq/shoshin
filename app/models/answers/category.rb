class Answers::Category < ApplicationRecord
  belongs_to :question, class_name: 'Questions::Classify', inverse_of: :answers, foreign_key: :question_id
  has_many :category_items, class_name: 'Answers::CategoryItem', inverse_of: :category, foreign_key: :answers_category_id, dependent: :destroy
  accepts_nested_attributes_for :category_items, allow_destroy: true

  validates :name, :question, presence: true

  delegate :exercise, to: :question, prefix: false
end
