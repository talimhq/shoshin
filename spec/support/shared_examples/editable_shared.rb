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

    context 'is_accessible_by(teacher)' do
      let(:teacher) { create(:teacher) }

      it 'returns true if editable is shared' do
        editable.update(shared: true)
        expect(editable.is_accessible_by(teacher)).to be_truthy
      end

      it 'returns true if editable is not shared and user is an author' do
        editable.update(shared: false, authors: [teacher])
        expect(editable.is_accessible_by(teacher)).to be_truthy
      end

      it 'returns false if editable is not shared and user is not an author' do
        editable.update(shared: false)
        expect(editable.is_accessible_by(teacher)).to be_falsy
      end
    end
  end
end
