FactoryGirl.define do
  factory :authorship do
    author { create(:teacher) }
    editable { create(:lesson) }
  end
end
