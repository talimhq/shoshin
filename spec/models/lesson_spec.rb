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

    it { expect(lesson.teaching.name).to eq(lesson.teaching.name) }
    it { expect { lesson.create_copy(teacher) }.to change(Lesson, :count).by(1) }
    it { expect { lesson.create_copy(teacher) }.to change(teacher.lessons, :count).by(1) }
    it { expect { lesson.create_copy(teacher) }.to change(lesson, :popularity).by(1) }
    it { expect(lesson.create_copy(teacher).original_id).to eq(lesson.id) }
    it { expect(lesson.create_copy(teacher).steps_count).to eq(lesson.steps_count) }
  end

  describe 'factories' do
    it { expect(create(:lesson)).to be_valid }
  end
end
