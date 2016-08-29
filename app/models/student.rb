class Student < ApplicationRecord
  include User

  before_validation :set_default_email
  before_validation :set_default_password

  belongs_to :classroom, inverse_of: :students, counter_cache: true
  has_many :student_groups, inverse_of: :student, dependent: :destroy
  has_many :groups, through: :student_groups

  validates :account, :classroom, presence: true

  def admin?
    false
  end

  def approved?
    true
  end

  private

  def set_default_email
    if account && account.email.blank?
      suffix = classroom.school.identifier.downcase
      prefix1 = I18n.transliterate(first_name).gsub(/\W+/, '').downcase
      prefix2 = I18n.transliterate(last_name).gsub(/\W+/, '').downcase
      account.email = "#{prefix1}.#{prefix2}@#{suffix}"
    end
  end

  def set_default_password
    if account && account.password.blank?
      account.password = '123456'
    end
  end
end
