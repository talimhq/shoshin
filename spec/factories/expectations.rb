FactoryGirl.define do
  factory :expectation do
    name { Faker::Lorem.word }
    theme
  end
end
