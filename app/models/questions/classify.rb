class Questions::Classify < Question
  has_many :answers, class_name: 'Answers::Category', inverse_of: :question, dependent: :destroy, foreign_key: :question_id
  has_many :category_items, through: :answers
  accepts_nested_attributes_for :answers, allow_destroy: true

  def validate_answer(answer)
    category_items.map { |item|
      answer[item.id.to_s] == item.category.name
    }.reduce(&:&)
  end
end
