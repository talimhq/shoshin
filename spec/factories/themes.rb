FactoryGirl.define do
  factory :theme do
    name { Faker::Lorem.word }
    teaching_cycle
    after(:build) do |theme|
      theme.theme_levels << build(:theme_level, theme: theme)
    end
  end
end
