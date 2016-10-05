FactoryGirl.define do
  factory :assignment do
    chapter
    exercise

    after :build do |assignment|
      unless assignment.chapter.teacher.in? \
        assignment.exercise.authors
        assignment.exercise.authors << assignment.chapter.teacher
      end
    end
  end
end
