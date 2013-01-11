require 'bundler/capistrano'

default_run_options[:pty] = true
set :rvm_ruby_string, 'ruby-1.9.3-p362'
set :rvm_type, :user

set :application, "lq_finance"
set :repository,  "git@gitcafe.com:everpointer/lqfina.git"
set :branch, "master"
set :scm, :git # You can set :scm explicitly or Capistrano will make an intelligent guess based on known version control directory names
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`
set :user, "laoyufu"
set :port, "22"

set :deploy_to, "/var/www/lq_fina"
set :deploy_via, :remote_cache
set :use_sudo, false

role :web, "oa.laicheap.com"                          # Your HTTP server, Apache/etc
role :app, "oa.laicheap.com"                          # This may be the same as your `Web` server
role :db,  "oa.laicheap.com", :primary => true # This is where Rails migrations will run

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# unicorn.rb 路径
set :unicorn_conf, "#{current_path}/config/unicorn.rb"
set :unicorn_pid, "#{current_path}/tmp/pids/unicorn.pid"

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  task :copy_config_files, :role => :app do
    db_config = "#{shared_path}/database.yml"
    run "cp #{db_config} #{release_path}/config/database.yml"
  end

  task :update_symlink do
    run "ln -s #{shared_path}/public/system #{current_path}/public/system"
  end

  task :start, :role => :app do
    run "cd #{current_path} && bundle exec unicorn_rails -c #{unicorn_conf} -E production -D"
  end
  task :stop, :role => :app do
    run "kill -QUIT `cat #{unicorn_pid}`"
  end

  desc "Restart Application"
  task :restart, :roles => :app do
    run "if [ -f #{unicorn_pid} ]; then kill -USR2 `cat #{unicorn_pid}`; else cd #{current_path} && bundle exec unicorn -c #{unicorn_conf} -E production -D; fi"
  end
end

# ======================================
# Set the default env in case it's not loading automatically 
# ======================================
set :default_environment, { 
  'PATH' => "/home/laoyufu/.rvm/gems/ruby-1.9.3-p362/bin:/home/laoyufu/.rvm/gems/ruby-1.9.3-p362@global/bin:/home/laoyufu/.rvm/rubies/ruby-1.9.3-p362/bin:/home/laoyufu/.rvm/bin:$PATH",
  'GEM_HOME' => '/home/laoyufu/.rvm/gems/ruby-1.9.3-p362',
  'GEM_PATH' => '/home/laoyufu/.rvm/gems/ruby-1.9.3-p362:/home/laoyufu/.rvm/gems/ruby-1.9.3-p362@global'
}

task :create_shared_dirs do
  run "mkdir -p #{shared_path}/log; mkdir -p #{shared_path}/pids"
end
before 'deploy:update', :create_share_dirs
# after "deploy:update_code", "deploy:install_bundler"
after "deploy:update_code", "deploy:copy_config_files" # 如果将database.yml放在shared下，请打开
# after "deploy:finalize_update", "deploy:update_symlink" # 如果有使用者上传文件到public/system, 请打开
