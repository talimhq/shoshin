require 'rails_helper'

RSpec.describe Authorship, type: :model do
  describe 'db structure' do
    it { is_expected.to have_db_column(:editable_id).of_type(:integer) }
    it { is_expected.to have_db_column(:editable_type).of_type(:string) }
    it { is_expected.to have_db_column(:teacher_id).of_type(:integer) }

    it { is_expected.to have_db_index(:teacher_id) }
    it { is_expected.to have_db_index([:editable_type, :editable_id]) }
    it { is_expected.to have_db_index([:editable_id, :teacher_id, :editable_type]).unique }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:editable) }
    it { is_expected.to belong_to(:author) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:author) }
    it { is_expected.to validate_presence_of(:editable) }
    it 'author cannot be listed twice for the same resource' do
      authorship = create(:authorship)
      new_authorship = build(:authorship, author: authorship.author, editable: authorship.editable)
      expect(new_authorship).not_to be_valid
    end
  end

  context 'factories' do
    describe 'for lessons' do
      it { expect(create(:authorship)).to be_persisted }
    end
  end
end
