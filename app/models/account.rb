class Account < ApplicationRecord
  after_destroy :destroy_user

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

  def active_for_authentication?
    if user_type == 'Teacher'
      super && user.approved?
    else
      super
    end
  end

  def inactive_message
    if user_type == 'Teacher' && !user.approved? && confirmed_at
      :not_approved
    else
      super
    end
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

  def self.role_options
    [%w(Professeur Teacher), %w(Parent Parent), %w(Élève Student)]
  end

  def display_role
    case user_type
    when 'Student'
      'Élève'
    when 'Parent'
      'Parent'
    when 'Teacher'
      'Professeur'
    end
  end

  private

  def destroy_user
    user.destroy
  end
end
