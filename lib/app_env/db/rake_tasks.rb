# Assumes have database set in ENV['DATA_URL']

require "rom/sql/rake_task"
require 'sequel'

require_relative 'config'
app_db_config = AppEnv::DB::Config.new

namespace :db do
  desc 'Create database'
  task :create do
    Sequel.connect(app_db_config.to_h.merge(database: :postgres)) do |db|
      db.execute "DROP DATABASE IF EXISTS #{app_db_config.database}"
      db.execute "CREATE DATABASE #{app_db_config.database}"
    end
  end

  desc 'Drop database'
  task :drop do
    Sequel.connect(app_db_config.to_h.merge(database: :postgres)) do |db|
      db.execute "DROP DATABASE IF EXISTS #{app_db_config.database}"
    end
  end
end

# Remnove the some database tasks from production
# # from https://stackoverflow.com/questions/31855366/rake-list-remove-custom-rake-task-in-specific-environment-development-pro
if AppEnv.production?
  tasks_to_disable = [
    "db:clean",
    "db:create",
    "db:create_migration",
    "db:drop",
    "db:reset"
  ]
  tasks = Rake.application.instance_variable_get("@tasks")
  tasks.delete_if { |task_name, _| tasks_to_disable.include?(task_name) }
end
