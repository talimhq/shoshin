FactoryGirl.define do
  factory :user_exercise_form do
    exercise

    trait :user do
      after :build do |user_exercise_form|
        user_exercise_form.user ||= build(%w(student teacher).sample.to_sym)
      end
    end

    trait :teacher do
      after :build do |user_exercise_form|
        user_exercise_form.user ||= build(:teacher)
      end
    end

    trait :student do
      after :build do |user_exercise_form|
        user_exercise_form.user ||= build(:student)
      end
    end

    factory :random_user_exercise_form, traits: [:user]
    factory :teacher_exercise_form, traits: [:teacher]
    factory :student_exercise_form, traits: [:student]
  end
end
