class Exercise < ApplicationRecord
  include Editable

  belongs_to :teaching, inverse_of: :exercises
  has_many :copies, class_name: 'Exercise', inverse_of: :original,
                    foreign_key: :original_id, dependent: :nullify
  belongs_to :original, class_name: 'Exercise', foreign_key: :original_id,
                        inverse_of: :copies, required: false
  has_many :authors, through: :authorships, source: :author,
                     inverse_of: :exercises
  has_many :questions, -> { order(position: :asc) }, inverse_of: :exercise,
                                                     dependent: :destroy
  has_many :user_exercise_forms, inverse_of: :exercise, dependent: :destroy
  has_many :chapter_exercises, inverse_of: :exercise, dependent: :destroy
  has_many :chapters, through: :chapter_exercises

  validates :name, :time, :popularity, :difficulty, :teaching,
            :questions_count, presence: true
  validates :exam, :shared, exclusion: { in: [nil] }
  validates :difficulty, inclusion: { in: [1, 2, 3] }

  delegate :name, to: :teaching, prefix: true
  delegate :short_name, to: :teaching, prefix: true

  ransacker :is_used do
    Arel.sql('(SELECT EXISTS (SELECT 1 FROM chapter_exercises WHERE chapter_exercises.exercise_id = exercises.id))')
  end

  def create_copy(user)
    copy = Exercise.new(name: name, teaching: teaching, level_ids: level_ids,
                        original_id: id, statement: statement, time: time,
                        exam: exam, difficulty: difficulty)
    questions.map { |question| question.build_copy(copy) }
    copy.save!
    copy.update(authors: [user])
    increment!(:popularity)
    copy
  end
end
