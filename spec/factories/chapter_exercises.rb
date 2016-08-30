FactoryGirl.define do
  factory :chapter_exercise do
    chapter
    exercise

    after :build do |chapter_exercise|
      unless chapter_exercise.chapter.teacher.in? \
        chapter_exercise.exercise.authors
        chapter_exercise.exercise.authors << chapter_exercise.chapter.teacher
      end
    end
  end
end
