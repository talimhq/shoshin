RSpec.shared_examples Editable do
  it { is_expected.to have_db_column(:level_ids).of_type(:integer) }
  it { is_expected.to validate_presence_of(:level_ids) }
  it { expect(editable.levels).to eq(Level.find(editable.level_ids)) }
  it { expect(editable.level_names).to eq(editable.levels.map(&:short_name).join(', ')) }
end
