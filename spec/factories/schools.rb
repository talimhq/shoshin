FactoryGirl.define do
  factory :school do
    name { Faker::University.name }
    identifier { "#{name.downcase.gsub(/\W+/, '')}.#{country}" }
    country { Faker::Address.country_code }
    state { country == 'FR' ? rand(1..95) : '99' }
    city { Faker::Address.city }
  end
end
