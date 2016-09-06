set :stage, :production
set :deploy_to, "/home/#{fetch(:user)}/apps/#{fetch(:application)}"
set :branch, :master
set :rails_env, 'production'

server '162.243.87.26', roles: [:web, :app, :db], primary: true
