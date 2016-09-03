FactoryGirl.define do
  factory :exercise do
    name { Faker::Book.title }
    teaching
    levels { [create(:level)] }
  end
end
