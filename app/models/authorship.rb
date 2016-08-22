class Authorship < ApplicationRecord
  belongs_to :author, class_name: 'Teacher', inverse_of: :authorships, foreign_key: :teacher_id
  belongs_to :editable, polymorphic: true, counter_cache: true

  validates :author, :editable, presence: true
  validates_uniqueness_of :author, scope: [:editable_id, :editable_type]
end
