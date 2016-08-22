FactoryGirl.define do
  factory :ability_set do
    name { Faker::Hacker.verb }
    teaching_cycle
  end
end
