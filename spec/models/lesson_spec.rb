require 'rails_helper'

RSpec.describe Lesson, type: :model do
  it_behaves_like Editable do
    let(:editable) { create(:lesson) }
  end

  describe 'db structure' do
    it { is_expected.to have_db_column(:name).of_type(:string) }
    it { is_expected.to have_db_column(:popularity).of_type(:integer) }
    it { is_expected.to have_db_column(:original_id).of_type(:integer) }
    it { is_expected.to have_db_column(:shared).of_type(:boolean) }
    it { is_expected.to have_db_column(:teaching_id).of_type(:integer) }
    it { is_expected.to have_db_column(:steps_count).of_type(:integer) }
    it { is_expected.to have_db_column(:authorships_count).of_type(:integer) }
    
    it { is_expected.to have_db_index(:teaching_id) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:teaching) }
    it { is_expected.to belong_to(:original) }
    it { is_expected.to have_many(:copies) }
    it { is_expected.to have_many(:authorships) }
    it { is_expected.to have_many(:authors) }
    it { is_expected.to have_many(:steps) }
    it { is_expected.to have_many(:chapter_lessons) }
    it { is_expected.to have_many(:chapters) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:popularity) }
    it { is_expected.to validate_exclusion_of(:shared).in_array([nil]) }
    it { is_expected.to validate_presence_of(:teaching) }
  end

  describe 'instance methods' do
    let!(:lesson) { create(:lesson) }
    let(:teacher) { create(:teacher) }

    it 'delegate teaching_name to teaching' do
      expect(lesson.teaching_name).to eq(lesson.teaching.name)
    end

    it 'delegate short_name to teaching' do
      expect(lesson.teaching_short_name).to eq(lesson.teaching.short_name)
    end

    context 'create_copy' do
      it 'creates a new Lesson' do
        expect { lesson.create_copy(teacher) }.to change(Lesson, :count).by(1)
      end

      it 'assign the copy to the teacher' do
        expect {
          lesson.create_copy(teacher)
        }.to change(teacher.lessons, :count).by(1)
      end

      it 'increases the original popularity' do
        expect {
          lesson.create_copy(teacher)
        }.to change(lesson, :popularity).by(1)
      end

      it 'sets the original_id of the copy' do
        expect(lesson.create_copy(teacher).original_id).to eq(lesson.id)
      end

      it 'copies the steps' do
        expect(lesson.create_copy(teacher).steps_count).to eq(lesson.steps_count)
      end
    end
  end

  describe 'factories' do
    it { expect(create(:lesson)).to be_valid }
  end
end
