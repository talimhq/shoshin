require 'sidekiq/web'

Rails.application.routes.draw do
  concern :paginable do
    get '(page/:page)', action: :index, on: :collection, as: ''
  end

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
                        path: 'utilisateurs', concerns: :paginable
      resources :schools, path: 'etablissements', concerns: :paginable
      patch 'etablissements/:school_id/professeurs/:teacher_id' => 'school_teachers#update', as: :school_teacher
      delete 'etablissements/:school_id/professeurs/:teacher_id' => 'school_teachers#destroy'
    end

    namespace :teacher, path: 'professeur' do
      concern :editable do |options|
        resources :authorships, { path: 'auteurs', only: [:index, :new, :create, :destroy] }.merge(options)
      end

      resources :teaching_cycles, path: 'referentiels', only: [:index],
                                  shallow: true do
        concerns :paginable
        resources :ability_sets, path: 'competences', only: [:index]
        resources :themes, only: [:index]
      end

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

      resources :groups, path: 'groupes', shallow: true do
        resources :chapters, path: 'chapitres', only: [:new, :create] do
          collection do
            post 'classer' => 'chapters#sort', as: :sort
          end
        end
        resources :messages, only: [:create]
      end

      get 'groupes/:id/eleves' => 'student_groups#edit', as: :group_students
      patch 'groupes/:id/eleves' => 'student_groups#update'

      resources :chapters, path: 'chapitres', except: [:index, :new, :create] do
        resources :assignments, path: 'exercices', except: [:index] do
          resources :student_exercise_forms, only: :show, as: :result
        end
      end

      get 'chapitres/:id/cours' => 'chapter_lessons#edit', as: :chapter_lessons
      patch 'chapitres/:id/cours' => 'chapter_lessons#update'

      resources :lessons, path: 'cours' do
        concerns :editable, editable_type: 'Lesson'
        concerns :paginable
        resources :steps, path: 'seances', except: [:index, :show], shallow: true
        get 'chercher(/page/:page)', to: 'shared_lessons#index',
                                     as: :search, on: :collection
        get 'apercu', to: 'shared_lessons#show', as: :preview, on: :member
        post 'copier', to: 'shared_lessons#create', as: :copy
      end

      resources :exercises, path: 'exercices' do
        concerns :editable, editable_type: 'Exercise'
        concerns :paginable
        resources :questions, except: [:index, :show], shallow: true do
          get 'reponses', to: 'answers#index', as: :answers, on: :member
          patch 'reponses', to: 'answers#update', on: :member
        end
        get 'chercher(/page/:page)', to: 'shared_exercises#index', as: :search, on: :collection
        post 'copier', to: 'shared_exercises#create', as: :copy
      end

      get '/exercices/:id/tester' => 'exercise_forms#new', as: :try_exercise
      post '/exercices/:id/tester' => 'exercise_forms#create'
      get '/exercices/:exercise_id/resultats/:id' => 'exercise_forms#show', as: :exercise_result
    end

    namespace :student, path: 'eleve' do
      resources :groups, path: 'groupes', only: :show do
        resources :messages, only: [:create]
      end

      resources :chapter_lessons, path: 'cours', only: :show
      resources :assignments, path: 'exercices', only: :show, shallow: true do
        resources 'student_exercise_forms', only: [:new, :create, :show],
                                            as: :exercise_forms,
                                            path: 'mes-exercices'
      end
      resources :chapters, path: 'chapitres', only: :show
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

  get '/pays/:country_id' => 'school_wizard#states'
  get '/pays/:country_id/dpt/:state_id' => 'school_wizard#cities'
  get '/pays/:country_id/dpt/:state_id/ville/:city_id' => 'school_wizard#schools'

  authenticate :account, -> (account) { account.user.admin? } do
    mount Sidekiq::Web, at: '/admin/sidekiq'
  end

  mount ActionCable.server => "/cable"
end
