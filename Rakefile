require "rom/sql/rake_task"
require 'sequel'
require 'uri'

require_relative 'app_dotenv'
AppEnv.load_dotenv

database_uri = ENV['DATABASE_URI']

class AppDB
  attr_accessor :adapter, :host, :port, :user, :password, :database
  def initialize(url)
    uri = URI.parse(url)
    @adapter = uri.scheme
    @host = uri.host
    @port = uri.port
    @user = uri.user
    @password = uri.password
    @database = uri.path.delete_prefix('/')
    @opts = URI::decode_www_form(uri.query).to_h if uri.query
  end

  def to_h
    {
      adapter: adapter,
      host: host,
      port: port,
      user: user,
      password: password,
      database: database,
    }.compact
  end
end

app_db = AppDB.new(database_uri)

namespace :db do
  desc 'Create database'
  task :create do
    Sequel.connect(app_db.to_h.merge(database: :postgres)) do |db|
      db.execute "DROP DATABASE IF EXISTS #{app_db.database}"
      db.execute "CREATE DATABASE #{app_db.database}"
    end
  end

  desc 'Drop database'
  task :drop do
    Sequel.connect(app_db.to_h.merge(database: :postgres)) do |db|
      db.execute "DROP DATABASE IF EXISTS #{app_db.database}"
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
