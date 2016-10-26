FactoryGirl.define do
  factory :user_exercise_form do
    exercise

    after :build do |user_exercise_form|
      user_exercise_form.user ||= build(:teacher)
    end
  end
end
