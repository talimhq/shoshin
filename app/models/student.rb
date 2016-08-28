class Student < ApplicationRecord
  before_validation :set_default_email
  before_validation :set_default_password

  has_one :account, as: :user, dependent: :destroy
  accepts_nested_attributes_for :account

  belongs_to :classroom, inverse_of: :students

  validates :account, :classroom, presence: true
  delegate :first_name, to: :account
  delegate :last_name, to: :account
  delegate :email, to: :account

  def admin?
    false
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
