FactoryGirl.define do
  factory :chapter_lesson do
    chapter
    lesson

    after :build do |chapter_lesson|
      unless chapter_lesson.chapter.teacher.in? chapter_lesson.lesson.authors
        chapter_lesson.lesson.authors << chapter_lesson.chapter.teacher
        chapter_lesson.lesson.save
      end
    end
  end
end
