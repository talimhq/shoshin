FactoryGirl.define do
  factory :step do
    content { Faker::Lorem.paragraph }
    lesson
  end
end
