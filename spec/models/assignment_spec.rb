require 'rails_helper'

RSpec.describe Assignment, type: :model do
  describe 'db structure' do
    it { is_expected.to have_db_column(:chapter_id).of_type(:integer) }
    it { is_expected.to have_db_index(:chapter_id) }
    it { is_expected.to have_db_column(:exercise_id).of_type(:integer) }
    it { is_expected.to have_db_index(:exercise_id) }
    it { is_expected.to have_db_index([:exercise_id, :chapter_id]).unique }
    it { is_expected.to have_db_column(:due_date).of_type(:datetime) }
    it { is_expected.to have_db_column(:position).of_type(:integer) }
    it { is_expected.to have_db_column(:max_tries).of_type(:integer) }
    it { is_expected.to have_db_column(:ability_evaluations).of_type(:jsonb) }
    it { is_expected.to have_db_column(:expectation_evaluations).of_type(:jsonb) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:chapter) }
    it { is_expected.to belong_to(:exercise) }
    it { is_expected.to have_many(:student_exercise_forms) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:chapter) }
    it { is_expected.to validate_presence_of(:exercise) }

    it 'does not add duplicate exercise to the same chapter' do
      assignment = create(:assignment)
      duplicate = build(:assignment, chapter: assignment.chapter,
                                           exercise: assignment.exercise)
      expect(duplicate).not_to be_valid
    end

    it 'chapter and exercise from different teacher are not valid' do
      chapter = create(:chapter)
      assignment = create(:assignment)
      expect(assignment.update(chapter: chapter)).to be_falsy
    end

    it 'chapter and exercise from same teacher are valid' do
      chapter = create(:chapter)
      exercise = create(:exercise)
      exercise.update(authors: [chapter.teacher])
      expect(build(:assignment, chapter: chapter, exercise: exercise)).to\
        be_valid
    end
  end

  describe 'instance methods' do
    let(:assignment) { create(:assignment) }

    it 'delegates questions to exercise' do
      create(:question, exercise: assignment.exercise)
      expect(assignment.questions).to eq(assignment.exercise.questions)
    end

    it 'delegates group to chapter' do
      expect(assignment.group).to eq(assignment.chapter.group)
    end
  end

  describe 'factories' do
    it { expect(build(:assignment)).to be_valid }
  end
end
