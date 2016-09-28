class GroupNotification < ApplicationRecord
  belongs_to :group, inverse_of: :group_notifications
  belongs_to :user, polymorphic: true, inverse_of: :group_notifications

  validates :group, :user, :body, :kind, presence: true
  validates :user_type, inclusion: { in: %w(Student Teacher) }
end
