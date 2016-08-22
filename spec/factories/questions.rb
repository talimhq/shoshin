FactoryGirl.define do
  factory :question do
    exercise
    content { Faker::Lorem.paragraph }
    type { Question.types.sample }

    trait :input do
      type 'Questions::Input'
    end

    trait :single_choice do
      type 'Questions::SingleChoice'
    end

    trait :multiple_choice do
      type 'Questions::MultipleChoice'
    end

    trait :classify do
      type 'Questions::Classify'
    end

    trait :association do
      type 'Questions::Association'
    end

    trait :redaction do
      type 'Questions::Redaction'
    end

    trait :file_upload do
      type 'Questions::FileUpload'
    end

    factory :input_question, traits: [:input]
    factory :single_choice_question, traits: [:single_choice]
    factory :multiple_choice_question, traits: [:multiple_choice]
    factory :classify_question, traits: [:classify]
    factory :association_question, traits: [:association]
    factory :redaction_question, traits: [:redaction]
    factory :file_upload_question, traits: [:file_upload]
  end
end
