class Answers::CategoryItem < ApplicationRecord
  belongs_to :category, class_name: 'Answers::Category', inverse_of: :category_items, foreign_key: :answers_category_id

  validates :content, :category, presence: true
end
