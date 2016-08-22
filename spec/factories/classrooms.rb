FactoryGirl.define do
  factory :classroom do
    name { Faker::Company.profession }
    level
    school
  end
end
