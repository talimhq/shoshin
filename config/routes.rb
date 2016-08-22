require 'sidekiq/web'

Rails.application.routes.draw do
  scope path_names: { new: 'nouveau', edit: 'Modifier' } do
    authenticated :account do
      root to: 'home#user'
    end
    root to: 'home#guest'

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

  mount Sidekiq::Web, at: '/admin/sidekiq'
end
