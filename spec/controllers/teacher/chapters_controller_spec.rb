require 'rails_helper'

RSpec.describe Teacher::ChaptersController, type: :controller do
  let!(:chapter) { create(:chapter) }

  describe 'GET #show' do
    context 'as a guest' do
      it 'redirects' do
        get :show, params: { id: chapter.id }
        expect(response).to have_http_status(302)
      end
    end

    context 'as a teacher' do
      let(:teacher) { create(:teacher) }
      before { sign_in teacher.account }

      context 'who does not own the chapter' do
        it 'redirects' do
          get :show, params: { id: chapter.id }
          expect(response).to have_http_status(302)
        end
      end

      context 'who owns the chapter' do
        before { chapter.group.update(teacher: teacher) }

        it 'is a success' do
          get :show, params: { id: chapter.id }
          expect(response).to have_http_status(200)
        end
      end
    end
  end

  describe 'GET #new' do
    context 'as a guest' do
      it 'redirects' do
        get :new, params: { group_id: chapter.group_id }
        expect(response).to have_http_status(302)
      end
    end

    context 'as a teacher' do
      let(:teacher) { create(:teacher) }
      before { sign_in teacher.account }

      context 'who does not own the group' do
        it 'redirects' do
          get :new, params: { group_id: chapter.group_id }
          expect(response).to have_http_status(302)
        end
      end

      context 'who owns the group' do
        before { chapter.group.update(teacher: teacher) }

        it 'is a success' do
          get :new, params: { group_id: chapter.group_id }
          expect(response).to have_http_status(200)
        end
      end
    end
  end

  describe 'POST #create' do
    context 'as a guest' do
      it 'does not create a chapter' do
        expect {
          post :create, params: { group_id: chapter.group_id,
                                  chapter: { name: 'foo' } }
        }.not_to change(Chapter, :count)
      end
    end

    context 'as a teacher' do
      let(:teacher) { create(:teacher) }
      before { sign_in teacher.account }

      context 'who does not own the group' do
        it 'does not create a chapter' do
          expect {
            post :create, params: { group_id: chapter.group_id,
                                    chapter: { name: 'foo' } }
          }.not_to change(Chapter, :count)
        end
      end

      context 'who owns the group' do
        before { chapter.group.update(teacher: teacher) }

        context 'with valid data' do
          it 'creates a chapter' do
            expect {
              post :create, params: { group_id: chapter.group_id,
                                      chapter: { name: 'foo' } }
            }.to change(Chapter, :count).by(1)
          end

          it 'redirects' do
            post :create, params: { group_id: chapter.group_id,
                                    chapter: { name: 'foo' } }
            expect(response).to have_http_status(302)
          end
        end

        context 'with invalid data' do
          it 'does not create a chapter' do
            expect {
              post :create, params: { group_id: chapter.group_id,
                                      chapter: { invalid: 'attribute' } }
            }.not_to change(Chapter, :count)
          end

          it 're renders the page' do
            post :create, params: { group_id: chapter.group_id,
                                    chapter: { invalid: 'attribute' } }
            expect(response).to have_http_status(200)
          end
        end
      end
    end
  end

  describe 'GET #edit' do
    context 'as a guest' do
      it 'redirects' do
        get :edit, params: { id: chapter.id }
        expect(response).to have_http_status(302)
      end
    end

    context 'as a teacher' do
      let(:teacher) { create(:teacher) }
      before { sign_in teacher.account }

      context 'who does not own the chapter' do
        it 'redirects' do
          get :edit, params: { id: chapter.id }
          expect(response).to have_http_status(302)
        end
      end

      context 'who owns the chapter' do
        before { chapter.group.update(teacher: teacher) }

        it 'is a success' do
          get :edit, params: { id: chapter.id }
          expect(response).to have_http_status(200)
        end
      end
    end
  end

  describe 'PATCH #update' do
    context 'as a guest' do
      it 'does not update the chapter' do
        expect {
          patch :update, params: { id: chapter.id, chapter: { name: 'foo' } }
        }.not_to change(chapter, :name)
      end
    end

    context 'as a teacher' do
      let(:teacher) { create(:teacher) }
      before { sign_in teacher.account }

      context 'who does not own the group' do
        it 'does not update the chapter' do
          patch :update, params: { id: chapter.id, chapter: { name: 'foo' } }
          expect(chapter.reload.name).not_to eq('')
        end
      end

      context 'who owns the group' do
        before { chapter.group.update(teacher: teacher) }

        context 'with valid data' do
          it 'updates the chapter' do
            patch :update, params: { id: chapter.id, chapter: { name: 'foo' } }
            expect(chapter.reload.name).to eq('foo')
          end

          it 'redirects' do
            patch :update, params: { id: chapter.id, chapter: { name: 'foo' } }
            expect(response).to have_http_status(302)
          end
        end

        context 'with invalid data' do
          it 'does not update the chapter' do
            patch :update, params: { id: chapter.id, chapter: { name: '' } }
            expect(chapter.reload.name).not_to eq('')
          end

          it 're renders the page' do
            patch :update, params: { id: chapter.id, chapter: { name: '' } }
            expect(response).to have_http_status(200)
          end
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'as a guest' do
      it 'does not destroy the chapter' do
        expect {
          delete :destroy, params: { id: chapter.id }
        }.not_to change(Chapter, :count)
      end
    end

    context 'as a teacher' do
      let(:teacher) { create(:teacher) }
      before { sign_in teacher.account }

      context 'who does not own the chapter' do
        it 'does not destroy the chapter' do
          expect {
            delete :destroy, params: { id: chapter.id }
          }.not_to change(Chapter, :count)
        end
      end

      context 'who owns the chapter' do
        before { chapter.group.update(teacher: teacher) }

        it 'destroys the chapter' do
          expect {
            delete :destroy, params: { id: chapter.id }
          }.to change(Chapter, :count).by(-1)
        end
      end
    end
  end

  describe 'POST #sort' do
    let(:group) { chapter.group }
    let(:chapter2) { create(:chapter, group: group) }

    before do
      chapter.update(position: 1)
      chapter2.update(position: 2)
    end

    context 'as a guest' do
      it 'does not update the position' do
        post :sort, params: { group_id: group.id,
                              chapter: [chapter2.id, chapter.id] }
        expect(group.chapters.reload).to eq([chapter, chapter2])
      end
    end

    context 'as a guest' do
      let(:teacher) { create(:teacher) }
      before { sign_in teacher.account }

      context 'who does not own the group' do
        it 'does not update the position' do
          post :sort, params: { group_id: group.id,
                                chapter: [chapter2.id, chapter.id] }
          expect(group.chapters.reload).to eq([chapter, chapter2])
        end
      end

      context 'who owns the group' do
        before { group.update(teacher: teacher) }

        it 'updates the position' do
          post :sort, params: { group_id: group.id,
                                chapter: [chapter2.id, chapter.id] }
          expect(group.chapters.reload).to eq([chapter2, chapter])
        end
      end
    end
  end
end
