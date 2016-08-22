FactoryGirl.define do
  factory :level do
    cycle
    name { %w(CP CE1 CE2 CM1 CM2 Sixième Cinquième Quatrième Troisième Seconde).sample }
    short_name { Faker::Company.name }
    level_type { Level.level_types.sample }
  end
end
