require 'rails_helper'

RSpec.describe Exercise, type: :model do
  it_should_behave_like Editable do
    let(:editable) { create(:exercise) }
  end

  describe 'db structure' do
    it { is_expected.to have_db_column(:name).of_type(:string) }
    it { is_expected.to have_db_column(:statement).of_type(:text) }
    it { is_expected.to have_db_column(:time).of_type(:integer) }
    it { is_expected.to have_db_column(:exam).of_type(:boolean) }
    it { is_expected.to have_db_column(:popularity).of_type(:integer) }
    it { is_expected.to have_db_column(:original_id).of_type(:integer) }
    it { is_expected.to have_db_column(:difficulty).of_type(:integer) }
    it { is_expected.to have_db_column(:authorships_count).of_type(:integer) }
    it { is_expected.to have_db_column(:shared).of_type(:boolean) }
    it { is_expected.to have_db_column(:teaching_id).of_type(:integer) }
    it { is_expected.to have_db_column(:questions_count).of_type(:integer) }
    it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
    it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }

    it { is_expected.to have_db_index(:teaching_id) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:teaching) }
    it { is_expected.to belong_to(:original) }
    it { is_expected.to have_many(:copies) }
    it { is_expected.to have_many(:authorships) }
    it { is_expected.to have_many(:authors) }
    it { is_expected.to have_many(:questions) }
    it { is_expected.to have_many(:teacher_exercise_forms) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:time) }
    it { is_expected.to validate_exclusion_of(:exam).in_array([nil]) }
    it { is_expected.to validate_presence_of(:popularity) }
    it { is_expected.to validate_presence_of(:questions_count) }
    it { is_expected.to validate_inclusion_of(:difficulty).in_array([1, 2, 3]) }
    it { is_expected.to validate_exclusion_of(:shared).in_array([nil]) }
    it { is_expected.to validate_presence_of(:teaching) }
  end

  describe 'instance methods' do
    let(:exercise)  { create(:exercise) }
    let!(:question) { create(:input_question, exercise: exercise) }
    let(:teacher) { create(:teacher) }

    it { expect(exercise.teaching_name).to eq(exercise.teaching.name) }
    it { expect { exercise.create_copy(teacher) }.to change(Exercise, :count).by(1) }
    it { expect { exercise.create_copy(teacher) }.to change(teacher.exercises, :count).by(1) }
    it { expect { exercise.create_copy(teacher) }.to change(exercise, :popularity).by(1) }
    it { expect(exercise.create_copy(teacher).original_id).to eq(exercise.id) }
    it { expect(exercise.create_copy(teacher).questions_count).to eq(exercise.questions_count) }
  end

  describe 'factories' do
    it { expect(create(:exercise)).to be_valid }
  end
end
