FactoryGirl.define do
  sequence(:name) { |n| "Classe #{n}" }

  factory :classroom do
    name
    level
    school
  end
end
