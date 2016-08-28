FactoryGirl.define do
  factory :parent do
    account { build(:parent_account) }
  end
end
