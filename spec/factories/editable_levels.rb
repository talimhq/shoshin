FactoryGirl.define do
  factory :editable_level do
    level

    trait :exercise do
      editable { build(:exercise) }
    end

    trait :lesson do
      editable { build(:lesson) }
    end

    factory :exercise_level, traits: [:exercise]
    factory :lesson_level, traits: [:lesson]
  end
end
