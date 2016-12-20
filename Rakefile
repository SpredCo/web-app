require 'rake/testtask'
# require 'dotenv'
#
RAKE_ENV = ENV['RAKE_ENV'] || 'development'
# Dotenv.load("env/#{RAKE_ENV}/.env")

Rake::TestTask.new do |t|
  t.pattern = 'spec/*/*_spec.rb'
end

task :default do
    sh "RACK_ENV='development' thin -R config.ru start --ssl --ssl-key-file ./.ssl/spred.key --ssl-cert-file ./.ssl/spred.crt"
end

task :install do
    sh 'bundle install'
    sh 'cd public && npm install'
end

namespace :vagrant do
    task :up do
      sh 'vagrant up'
      sh 'vagrant ssh -c "cd /vagrant && rake"'
    end
    task :stop do
      sh 'vagrant halt'
    end
    task :co do
      sh 'vagrant ssh'
    end
end

namespace :heroku do
    task :logs do
        sh 'heroku logs --app web-spred -t'
    end
    task :start do
        sh 'heroku ps:scale web=1 -a web-spred'
    end
    task :stop do
        sh 'heroku ps:scale web=0 -a web-spred'
    end
end
