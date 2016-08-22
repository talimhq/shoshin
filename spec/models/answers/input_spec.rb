require 'rails_helper'

RSpec.describe Answers::Input, type: :model do
  describe 'db structure' do
    it { is_expected.to have_db_column(:content).of_type(:string) }
    it { is_expected.to have_db_column(:question_id).of_type(:integer) }

    it { is_expected.to have_db_index(:question_id) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:question) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:content) }
    it { is_expected.to validate_presence_of(:question) }
  end

  describe 'instance methods' do
    let(:answer) { create(:answers_input) }

    it { expect(answer.exercise).to eq(answer.question.exercise) }
  end

  describe 'factories' do
    it { expect(create(:answers_input)).to be_valid }
  end
end
