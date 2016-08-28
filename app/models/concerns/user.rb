module User
  def self.included(base)
    base.class_eval do
      has_one :account, as: :user, dependent: :destroy
      accepts_nested_attributes_for :account

      delegate :first_name, to: :account
      delegate :last_name, to: :account
      delegate :email, to: :account
      delegate :full_name, to: :account
    end
  end
end
