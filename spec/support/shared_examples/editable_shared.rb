RSpec.shared_examples Editable do
  describe 'associations' do
    it { is_expected.to have_many(:editable_levels) }
    it { is_expected.to have_many(:levels) }
  end

  describe 'instance methods' do
    it 'delegate level_names to levels' do
      expect(editable.level_names).to \
        eq(editable.levels.map(&:short_name).join(', '))
    end
  end
end
