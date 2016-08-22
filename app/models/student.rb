class Student < ApplicationRecord
  has_one :account, as: :user, dependent: :destroy
  accepts_nested_attributes_for :account

  belongs_to :classroom, inverse_of: :students

  validates :account, :classroom, presence: true
end
