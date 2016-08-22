FactoryGirl.define do
  factory :answers_association, class: 'Answers::Association' do
    left { Faker::Lorem.word }
    right { Faker::Lorem.word }
    question { create(:association_question).becomes(Questions::Association) }
  end

  factory :answers_category, class: 'Answers::Category' do
    name { Faker::Lorem.word }
    question { create(:classify_question).becomes(Questions::Classify) }
  end

  factory :answers_category_item, class: 'Answers::CategoryItem' do
    content { Faker::Lorem.word }
    category { create(:answers_category) }
  end

  factory :answers_crossword, class: 'Answers::Crossword' do
    word { Faker::Lorem.word }
    clue { Faker::Lorem.sentence }
    question { create(:crossword_question).becomes(Questions::Crossword) }
  end

  factory :answers_input, class: 'Answers::Input' do
    content { Faker::Lorem.word }
    question { create(:input_question).becomes(Questions::Input) }
  end

  factory :answers_multiple_choice, class: 'Answers::MultipleChoice' do
    content { Faker::Lorem.word }
    question { create(:multiple_choice_question).becomes(Questions::MultipleChoice) }
  end

  factory :answers_single_choice, class: 'Answers::SingleChoice' do
    content { Faker::Lorem.word }
    question { create(:single_choice_question).becomes(Questions::SingleChoice) }
  end

  factory :answers_file_upload, class: 'Answers::FileUpload' do
    file_format { Faker::File.extension }
    question { create(:file_upload_question).becomes(Questions::FileUpload) }
  end
end
