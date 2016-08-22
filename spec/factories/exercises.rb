FactoryGirl.define do
  factory :exercise do
    name { Faker::Book.title }
    teaching
    level_ids { [create(:level).id] }
  end
end
