FactoryGirl.define do
  sequence(:email) { |n| "user#{n}@shoshin.academy" }
  factory :account do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email
    password '123456789'
    confirmed_at { Faker::Time.backward(14) }

    trait :user do
      after(:build) do |account|
        account.user ||= build(%w(student parent teacher).sample.to_sym, account: account)
      end
    end

    trait :student do
      after(:build) do |account|
        account.user ||= build(:student, account: account)
      end
    end

    trait :parent do
      after(:build) do |account|
        account.user ||= build(:parent, account: account)
      end
    end

    trait :teacher do
      after(:build) do |account|
        account.user ||= build(:teacher, account: account)
      end
    end

    trait :admin do
      after(:build) do |account|
        account.user ||= build(:teacher, account: account, admin: true)
      end
    end

    factory :admin_account, traits: [:admin]
    factory :student_account, traits: [:student]
    factory :parent_account, traits: [:parent]
    factory :teacher_account, traits: [:teacher]
    factory :user_account, traits: [:user]
  end
end
