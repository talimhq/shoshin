require 'rails_helper'

RSpec.describe Admin::LevelsController, type: :controller do
  let(:level1) { create(:level, position: 1) }
  let(:level2) { create(:level, cycle: level1.cycle, position: 2) }

  context 'as a guest' do
    it { expect(post(:sort, params: { level: [level2.id, level1.id] })).to have_http_status(302) }
    it 'does not change levels position' do
      post :sort, params: { level: [level2.id, level1.id] }
      expect(level1.cycle.reload.levels).to eq([level1, level2])
    end
  end

  context 'as a user' do
    before { sign_in create(:user) }

    it { expect(post(:sort, params: { level: [level2.id, level1.id] })).to have_http_status(302) }
    it 'does not change levels position' do
      post :sort, params: { level: [level2.id, level1.id] }
      expect(level1.cycle.reload.levels).to eq([level1, level2])
    end
  end

  context 'as an admin' do
    before { sign_in create(:admin) }

    it { expect(post(:sort, params: { level: [level2.id, level1.id] })).to have_http_status(200) }
    it 'changes levels position' do
      post :sort, params: { level: [level2.id, level1.id] }
      expect(level1.cycle.reload.levels).to eq([level2, level1])
    end
  end
end
