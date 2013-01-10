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

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  task :copy_config_files, :role => [:app] do
    db_conifg = "#{shared_path}/config/database.yml"
    run "cp #{db_config} #{releases_path}/config/database.yml"
  end

  task :update_symlink do
    run "ln -s #{shared_path}/public/system #{current_path}/public/system"
  end
  task :bundle_install, :roles => :app do
    run "cd #{release_path} && bundle install"
  end

  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end

after "deploy:update_code", "deploy:copy_config_files" # 如果将database.yml放在shared下，请打开
after "deploy:update_code", "deploy:bundle_install"
# after "deploy:finalize_update", "deploy:update_symlink" # 如果有使用者上传文件到public/system, 请打开
require 'bundler/capistrano'
