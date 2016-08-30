FactoryGirl.define do
  factory :chapter do
    group
    name { Faker::Book.title }
  end
end
