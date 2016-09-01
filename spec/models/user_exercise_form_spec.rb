require 'rails_helper'

RSpec.describe UserExerciseForm, type: :model do
  describe 'db structure' do
    it { is_expected.to have_db_column(:exercise_id).of_type(:integer) }
    it { is_expected.to have_db_column(:user_id).of_type(:integer) }
    it { is_expected.to have_db_column(:user_type).of_type(:string) }
    it { is_expected.to have_db_column(:answers).of_type(:jsonb) }
    it { is_expected.to have_db_column(:results).of_type(:jsonb) }
    it { is_expected.to have_db_index(:exercise_id) }
    it { is_expected.to have_db_index([:user_type, :user_id]) }
    it { is_expected.to have_db_index(:answers) }
    it { is_expected.to have_db_index(:results) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:exercise) }
    it { is_expected.to belong_to(:user) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:exercise) }
    it { is_expected.to validate_presence_of(:user) }
    it { is_expected.to validate_inclusion_of(:user_type).in_array(%w(Student Teacher)) }
  end

  describe 'instance methods' do
    let(:teacher_exercise_form) { create(:teacher_exercise_form) }

    it 'returns exercise_name' do
      expect(teacher_exercise_form.exercise_name).to eq(teacher_exercise_form.exercise.name)
    end

    it 'returns exercise_statement' do
      expect(teacher_exercise_form.exercise_statement).to eq(teacher_exercise_form.exercise.statement)
    end

    it 'returns the exercise questions' do
      create(:input_question, exercise: teacher_exercise_form.exercise)
      expect(teacher_exercise_form.questions.length).to eq(1)
    end
  end

  describe 'factories' do
    it { expect(build(:random_user_exercise_form)).to be_valid }
    it { expect(build(:teacher_exercise_form)).to be_valid }
    it { expect(build(:student_exercise_form)).to be_valid }
  end
end
