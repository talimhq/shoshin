FactoryGirl.define do
  factory :school_teacher do
    school
    teacher
    approved true

    trait :unapproved do
      approved false
    end

    factory :unapproved_school_teacher, traits: [:unapproved]
  end
end
