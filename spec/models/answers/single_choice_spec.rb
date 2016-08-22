require 'rails_helper'

RSpec.describe Answers::SingleChoice, type: :model do
  describe 'db structure' do
    it { is_expected.to have_db_column(:content).of_type(:string) }
    it { is_expected.to have_db_column(:correct).of_type(:boolean) }
    it { is_expected.to have_db_column(:question_id).of_type(:integer) }

    it { is_expected.to have_db_index(:question_id) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:question) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:question) }
    it { is_expected.to validate_presence_of(:content) }
    it { is_expected.to validate_exclusion_of(:correct).in_array([nil]) }
  end

  describe 'instance methods' do
    let(:answer) { create(:answers_single_choice) }

    it { expect(answer.exercise).to eq(answer.question.exercise) }
  end

  describe 'factories' do
    it { expect(create(:answers_single_choice)).to be_valid }
  end
end
