FactoryGirl.define do
  factory :ability_item do
    name { Faker::Hacker.verb }
    ability_set
  end
end
