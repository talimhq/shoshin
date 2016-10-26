require 'rails_helper'

RSpec.describe StudentExerciseForm, type: :model do
  describe 'db structure' do
    it { is_expected.to have_db_column(:student_id).of_type(:integer) }
    it { is_expected.to have_db_column(:assignment_id).of_type(:integer) }
    it { is_expected.to have_db_column(:answers).of_type(:jsonb) }
    it { is_expected.to have_db_column(:results).of_type(:jsonb) }
    it { is_expected.to have_db_index(:student_id) }
    it { is_expected.to have_db_index(:assignment_id) }
    it { is_expected.to have_db_index(:answers) }
    it { is_expected.to have_db_index(:results) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:assignment) }
    it { is_expected.to belong_to(:student) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:student) }
    it { is_expected.to validate_presence_of(:assignment) }
  end

  describe 'factories' do
    it { expect(build(:student_exercise_form)).to be_valid }
  end
end
