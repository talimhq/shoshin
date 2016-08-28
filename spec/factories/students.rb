FactoryGirl.define do
  factory :student do
    classroom
    after :build do |student|
      student.account ||= build(:student_account, user: student)
    end
  end
end
