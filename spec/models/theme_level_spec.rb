require 'rails_helper'

RSpec.describe ThemeLevel, type: :model do
  describe 'db structure' do
    it { is_expected.to have_db_column(:theme_id).of_type(:integer) } 
    it { is_expected.to have_db_column(:level_id).of_type(:integer) } 
    it { is_expected.to have_db_column(:kind).of_type(:string) } 

    it { is_expected.to have_db_index(:theme_id) }
    it { is_expected.to have_db_index(:level_id) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:theme) }
    it { is_expected.to belong_to(:level) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:theme) }
    it { is_expected.to validate_presence_of(:level) }
    it { is_expected.to validate_presence_of(:kind) }
    it { is_expected.to validate_inclusion_of(:kind).in_array(ThemeLevel.kinds) }
  end

  describe 'class methods' do
    it { expect(ThemeLevel.kinds).to eq(%w(Obligatoire Spécialité Facultatif)) }
  end

  describe 'factories' do
    it { expect(create(:theme_level)).to be_valid }
  end
end
