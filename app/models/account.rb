class Account < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable, :lockable,
         :recoverable, :rememberable, :trackable, :validatable

  belongs_to :user, polymorphic: true
  validates :first_name, :last_name, presence: true
  validates :user_type, inclusion: { in: %w(Student Parent Teacher) }

  def self.user_types
    %w(Student Parent Teacher)
  end

  def full_name
    [first_name, last_name].join(' ')
  end

  def send_devise_notification(notification, *args)
    devise_mailer.send(notification, self, *args).deliver_later
  end

  def role
    user_type.downcase
  end
end
