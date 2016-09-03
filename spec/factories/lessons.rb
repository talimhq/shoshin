FactoryGirl.define do
  factory :lesson do
    name { Faker::Book.title }
    teaching
    levels { [create(:level)] }
  end
end
