FactoryGirl.define do
  factory :lesson do
    name { Faker::Book.title }
    teaching
    level_ids { [create(:level).id] }
  end
end
