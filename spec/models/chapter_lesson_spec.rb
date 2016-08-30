require 'rails_helper'

RSpec.describe ChapterLesson, type: :model do
  describe 'db structure' do
    it { is_expected.to have_db_column(:chapter_id).of_type(:integer) }
    it { is_expected.to have_db_index(:chapter_id) }
    it { is_expected.to have_db_column(:lesson_id).of_type(:integer) }
    it { is_expected.to have_db_index(:lesson_id) }
    it { is_expected.to have_db_index([:lesson_id, :chapter_id]).unique }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:chapter) }
    it { is_expected.to belong_to(:lesson) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:chapter) }
    it { is_expected.to validate_presence_of(:lesson) }

    it 'does not add duplicate lessons to the same chapter' do
      chapter_lesson = create(:chapter_lesson)
      duplicate = build(:chapter_lesson, chapter: chapter_lesson.chapter,
                                         lesson: chapter_lesson.lesson)
      expect(duplicate).not_to be_valid
    end

    it 'chapter and lesson from different teacher are not valid' do
      chapter = create(:chapter)
      chapter_lesson = create(:chapter_lesson)
      expect(chapter_lesson.update(chapter: chapter)).to be_falsy
    end

    it 'chapter and lesson from same teacher are valid' do
      chapter = create(:chapter)
      lesson = create(:lesson)
      lesson.update(authors: [chapter.teacher])
      expect(build(:chapter_lesson, chapter: chapter, lesson: lesson)).to \
        be_valid
    end
  end

  describe 'factories' do
    it { expect(build(:chapter_lesson)).to be_valid }
  end
end
