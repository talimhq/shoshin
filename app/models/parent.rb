class Parent < ApplicationRecord
  include User

  has_one :account, as: :user, dependent: :destroy
  validates :account, presence: true

  def admin?
    false
  end

  def approved?
    true
  end
end
