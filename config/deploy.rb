# config valid only for current version of Capistrano
lock '3.6.1'

set :application, 'shoshin'
set :user, 'sensei'
set :deploy_via, :remote_cache

# git
set :scm, :git
set :repo_url, 'git@github.com:TalimSolutions/shoshin.git'
set :branch, 'master'
set :keep_releases, 5
set :ssh_options, { forward_agent: true, user: fetch(:user), keys: %w(~/.ssh/id_rsa.pub) }

# rbenv
set :rbenv_type, :user
set :rbenv_ruby, '2.3.1'

# Sidekiq bug
set :pty, false

# Puma
set :puma_preload_app, true
set :puma_init_active_record, true

# Defaults
set :format, :pretty
set :log_level, :debug

set :linked_files, %w{config/database.yml}
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}
