FactoryGirl.define do
  sequence(:email) { |n| "user#{n}@shoshin.academy" }
  factory :account do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email
    password '123456'
    confirmed_at { Faker::Time.backward(14) }

    after(:build) do |account|
      account.user = build(:teacher, account: account) unless account.user
    end
  end
end
