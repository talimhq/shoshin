require 'rails_helper'

RSpec.describe Teacher::SharedExercisesController, type: :controller do
  let!(:exercise) { create(:exercise) }
  let(:secret_exercise) { create(:exercise, shared: false) }

  context 'as a guest' do
    it { expect(get(:index)).to have_http_status(302) }
    it { expect(post(:create, params: { exercise_id: exercise.id })).to have_http_status(302) }
    it { expect { post(:create, params: { exercise_id: exercise.id }) }.not_to change(Exercise, :count) }
  end

  context 'as a student' do
    before { sign_in create(:student_account) }
    it { expect(get(:index)).to have_http_status(302) }
    it { expect(post(:create, params: { exercise_id: exercise.id })).to have_http_status(302) }
    it { expect { post(:create, params: { exercise_id: exercise.id }) }.not_to change(Exercise, :count) }
  end

  context 'as a parent' do
    before { sign_in create(:parent_account) }
    it { expect(get(:index)).to have_http_status(302) }
    it { expect(post(:create, params: { exercise_id: exercise.id })).to have_http_status(302) }
    it { expect { post(:create, params: { exercise_id: exercise.id }) }.not_to change(Exercise, :count) }
  end

  context 'as a teacher' do
    before { sign_in create(:teacher_account) }
    it { expect(get(:index)).to have_http_status(200) }
    it { expect(post(:create, params: { exercise_id: exercise.id })).to have_http_status(302) }
    it { expect { post(:create, params: { exercise_id: exercise.id }) }.to change(Exercise, :count).by(1) }
    it 'increase popularity' do
      post :create, params: { exercise_id: exercise.id }
      expect(exercise.reload.popularity).to eq(1)
    end
  end
end
