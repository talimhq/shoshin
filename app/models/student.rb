class Student < ApplicationRecord
  include User

  before_validation :set_default_email
  before_validation :set_default_password

  belongs_to :classroom, inverse_of: :students, counter_cache: true
  has_many :student_groups, inverse_of: :student, dependent: :destroy
  has_many :groups, through: :student_groups
  has_many :user_exercise_forms, -> { order(created_at: :asc) },
           as: :user, dependent: :destroy
  has_many :done_exercises, through: :user_exercise_forms, source: :exercise

  validates :account, :classroom, presence: true

  def admin?
    false
  end

  def approved?
    true
  end

  private

  def transliterate_and_downcase(string)
    I18n.transliterate(string).gsub(/\W+/, '').downcase
  end

  def set_default_email
    if account && account.email.blank?
      suffix = classroom.school.identifier.downcase
      prefix2 = transliterate_and_downcase(first_name)
      prefix1 = transliterate_and_downcase(last_name)
      account.email = "#{prefix1}.#{prefix2}@#{suffix}"
    end
  end

  def set_default_password
    account.password = '123456' if account && account.password.blank?
  end
end
