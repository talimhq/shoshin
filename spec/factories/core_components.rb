FactoryGirl.define do
  factory :core_component do
    name { Faker::Superhero.power }
  end
end
