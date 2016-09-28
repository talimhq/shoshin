FactoryGirl.define do
  factory :group_notification do
    group
    user { create([:student, :teacher].sample) }
    body { Faker::Lorem.word }
    kind 'message'
  end
end
