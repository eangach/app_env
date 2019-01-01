require "rom/sql/rake_task"

require_relative 'app_dotenv'
AppEnv.load_dotenv
pp ENV.sort

namespace :db do
  desc 'create database'
  task :create do
  end

  desc 'drop database'
  task :drop do
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
