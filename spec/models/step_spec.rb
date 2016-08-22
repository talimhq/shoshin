require 'rails_helper'

RSpec.describe Step, type: :model do
  describe 'db structure' do
    it { is_expected.to have_db_column(:position).of_type(:integer) }
    it { is_expected.to have_db_column(:title).of_type(:string) }
    it { is_expected.to have_db_column(:content).of_type(:text) }
    it { is_expected.to have_db_column(:lesson_id).of_type(:integer) }

    it { is_expected.to have_db_index(:lesson_id) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:lesson) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:content) }
    it { is_expected.to validate_presence_of(:lesson) }
  end

  context 'factories' do
    describe 'standard one' do
      it { expect(create(:step)).to be_valid }
    end
  end

  describe 'instance methods' do
    it { expect(create(:step).print_title).to eq('Séance 1') }
    it { expect(create(:step, title: 'foo').print_title).to eq('foo') }

    it 'delegates authors to lesson' do
      teacher = create(:teacher)
      lesson = create(:lesson)
      create(:authorship, author: teacher, editable: lesson)
      step = create(:step, lesson: lesson)
      expect(step.authors).to eq(lesson.authors)
    end

    context 'build_copy' do
      let!(:original) { create(:step) }
      let(:new_lesson) { build(:lesson) }

      before { original.build_copy(new_lesson) }

      it { expect(new_lesson.steps.length).to eq(1) }
      it { expect(new_lesson.steps.first.content).to eq(original.content) }
      it { expect(new_lesson.steps.first.title).to eq(original.title) }
      it { expect(new_lesson.steps.first.position).to eq(original.position) }
    end
  end
end
