require 'rails_helper'

RSpec.describe Teacher, type: :model do
  it_should_behave_like User do
    let(:user) { create(:teacher) }
  end

  describe 'db structure' do
    it { is_expected.to have_db_column(:approved).of_type(:boolean) }
    it { is_expected.to have_db_column(:admin).of_type(:boolean) }
    it { is_expected.to have_db_column(:old_id).of_type(:integer) }
    it { is_expected.to have_db_index(:old_id) }
  end

  describe 'associations' do
    it { is_expected.to have_one(:school_teacher) }
    it { is_expected.to have_one(:school) }
    it { is_expected.to have_many(:authorships) }
    it { is_expected.to have_many(:lessons) }
    it { is_expected.to have_many(:exercises) }
    it { is_expected.to have_many(:teacher_teaching_cycles) }
    it { is_expected.to have_many(:user_exercise_forms) }
    it { is_expected.to have_many(:groups) }
    it { is_expected.to have_many(:group_notifications) }
  end

  describe 'validations' do
    it { is_expected.to validate_exclusion_of(:approved).in_array([nil]) }
    it { is_expected.to validate_exclusion_of(:admin).in_array([nil]) }
  end

  describe 'factories' do
    it { expect(build(:teacher)).to be_valid }
  end

  describe 'instance methods' do
    let(:teacher) { create(:teacher) }

    context 'exercises_from_level(level)' do
      it 'fetches the exercises' do
        exercise1 = create(:exercise)
        exercise2 = create(:exercise)
        exercise1.update(authors: [teacher])
        exercise2.update(authors: [teacher])
        level = Level.find(exercise1.level_ids.first)
        expect(teacher.exercises_from_level(level)).to eq([exercise1])
      end
    end

    context 'lessons_from_level(level)' do
      it 'fetches the lessons' do
        lesson1 = create(:lesson)
        lesson2 = create(:lesson)
        lesson1.update(authors: [teacher])
        lesson2.update(authors: [teacher])
        level = Level.find(lesson1.level_ids.first)
        expect(teacher.lessons_from_level(level)).to eq([lesson1])
      end
    end
  end
end
