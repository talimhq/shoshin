require 'rails_helper'

RSpec.describe Question, type: :model do
  describe 'db structure' do
    it { is_expected.to have_db_column(:position).of_type(:integer) }
    it { is_expected.to have_db_column(:content).of_type(:text) }
    it { is_expected.to have_db_column(:help).of_type(:text) }
    it { is_expected.to have_db_column(:type).of_type(:string) }
    it { is_expected.to have_db_column(:exercise_id).of_type(:integer) }

    it { is_expected.to have_db_index(:exercise_id) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:exercise) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:content) }
    it { is_expected.to validate_presence_of(:type) }
    it { is_expected.to validate_inclusion_of(:type).in_array(Question.types) }
    it { is_expected.to validate_presence_of(:exercise) }
  end

  describe 'class method' do
    it { expect(Question.type_options.map(&:last).flatten).to eq(Question.types) }
  end

  describe 'instance methods' do
    let(:question) { create(:question) }

    it 'delegates authors to exercise' do
      teacher = create(:teacher)
      exercise = question.exercise
      create(:authorship, author: teacher, editable: exercise)
      expect(question.authors).to eq(exercise.authors)
    end

    it { expect(question.exercise_name).to eq(question.exercise.name) }
    it { expect(question.exercise_statement).to eq(question.exercise.statement) }
    it { expect(question.print_title).to eq('Question 1') }

    context 'build_copy' do
      let(:new_exercise) { build(:exercise) }

      before { question.build_copy(new_exercise) }

      it { expect(new_exercise.questions.length).to eq(1) }
      it { expect(new_exercise.questions.first.content).to eq(question.content) }
      it { expect(new_exercise.questions.first.position).to eq(question.position) }
    end
  end

  describe 'factories' do
    it { expect(create(:question)).to be_valid }
  end
end
