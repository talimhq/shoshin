FactoryGirl.define do
  factory :theme_level do
    theme 
    level 
    kind { ThemeLevel.kinds.sample } 
  end
end
