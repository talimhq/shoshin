FactoryGirl.define do
  factory :teacher do
    approved true
    after :build do |teacher|
      teacher.account ||= build(:teacher_account, user: teacher)
    end
  end
end
