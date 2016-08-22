FactoryGirl.define do
  factory :teaching do
    name { Faker::Commerce.department(2, true) }
    short_name { Faker::Hacker.abbreviation }
    after(:build) do |teaching|
      teaching.cycles << create(:cycle)
    end
  end
end
