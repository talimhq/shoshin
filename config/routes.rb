require 'sidekiq/web'

Rails.application.routes.draw do
  scope path_names: { new: 'nouveau', edit: 'modifier' } do
    namespace :admin do
      resources :teachings, path: 'enseignements',
                            except: [:show]
      resources :teaching_cycles, only: [:show],
                                  path: 'enseignements',
                                  shallow: true do
        resources :themes, except: [:index] do
          resources :expectations, only: [:new, :create, :edit, :update,
                                          :destroy],
                                   path: 'attendus'
          post 'classer', to: 'themes#sort', as: :sort, on: :collection
        end
        resources :ability_sets, path: 'competences', except: [:show, :index]
        post 'competences/classer', to: 'ability_sets#sort',
                                    as: :sort_ability_sets
      end
      resources :cycles, except: [:show]
      resources :core_components, except: [:show], path: 'socle'
      post 'cycles/classer', to: 'cycles#sort', as: :sort_cycles
      post 'niveaux/classer', to: 'levels#sort', as: :sort_levels
      resources :users, only: [:index, :edit, :update, :destroy],
                        path: 'utilisateurs'
      resources :schools, path: 'etablissements'
      patch 'etablissements/:school_id/professeurs/:teacher_id' => 'school_teachers#update', as: :school_teacher
      delete 'etablissements/:school_id/professeurs/:teacher_id' => 'school_teachers#destroy'
    end

    namespace :teacher, path: 'professeur' do
      concern :editable do |options|
        resources :authorships, { path: 'auteurs', only: [:index, :new, :create, :destroy] }.merge(options)
      end

      resources :teaching_cycles, path: 'enseignements', only: nil, shallow: true do
        resources :ability_sets, path: 'competences', only: [:index]
        resources :themes, only: [:index, :show]
      end

      resources :teacher_teaching_cycles, path: 'referentiels',
                                       only: [:index, :create, :destroy]
      resources :school_teachers, path: 'trouver-etablissement',
                               only: [:new, :create, :update, :destroy]
      resources :schools, path: 'etablissement',
                          only: [:new, :create, :show],
                          shallow: true do
        resources :classrooms, except: [:index], path: 'classes',
                               shallow: true do
          resources :students, path: 'eleves', except: [:index, :show]
        end
      end

      patch '/eleves/:id/motdepasse' => 'student_passwords#update', as: :student_password

      resources :groups, path: 'groupes'

      resources :lessons, path: 'cours' do
        concerns :editable, editable_type: 'Lesson'
        resources :steps, path: 'seances', except: [:index, :show], shallow: true
        get 'chercher', to: 'shared_lessons#index', as: :search, on: :collection
        post 'copier', to: 'shared_lessons#create', as: :copy
      end

      resources :exercises, path: 'exercices' do
        concerns :editable, editable_type: 'Exercise'
        resources :questions, except: [:index, :show], shallow: true do
          get 'reponses', to: 'answers#index', as: :answers, on: :member
          patch 'reponses', to: 'answers#update', on: :member
        end
        get 'chercher', to: 'shared_exercises#index', as: :search, on: :collection
        post 'copier', to: 'shared_exercises#create', as: :copy
      end

      get '/exercices/:id/tester' => 'exercise_forms#new', as: :try_exercise
      post '/exercices/:id/tester' => 'exercise_forms#create'
      get '/exercices/:exercise_id/resultats/:id' => 'exercise_forms#show', as: :exercise_result
    end

    authenticated :account do
      root to: 'home#user'
    end
    root to: 'home#guest'

    resources :public_schools, path: 'etablissements', only: [:new, :create]

    devise_for :accounts, path: '',
                          path_names: {
                            sign_in: 'connexion',
                            sign_out: 'deconnexion',
                            registration: 'inscription',
                            password: 'motdepasse',
                            unlock: 'deblocage',
                            sign_up: 'nouveau',
                            cancel: 'annuler'
                          },
                          controllers: {
                            sessions: 'accounts/sessions',
                            registrations: 'accounts/registrations',
                            confirmations: 'accounts/confirmations',
                            passwords: 'accounts/passwords',
                            unlocks: 'accounts/unlocks'
                          }
  end

  authenticate :account, -> (account) { account.user.admin? } do
    mount Sidekiq::Web, at: '/admin/sidekiq'
  end
end
