# Load dotenv files depending on enviornment set in ENV['APP_ENV'].

class AppEnv
  def self.root
    Pathname.new(Dir.pwd)
  end

  def self.env
    ENV['APP_ENV'] || ENV['RACK_ENV'] || 'development'
  end

  def self.dotenv_files
    [
      root.join(".env.#{env}.local"),
      (root.join(".env.local") unless env == 'test'),
      root.join(".env.#{env}"),
      root.join(".env")
    ].compact
  end

  def self.load_dotenv
    require 'dotenv'
    Dotenv.load(*dotenv_files)
  end

  def self.production?
    env == 'production'
  end

  def self.test?
    env == 'test'
  end

  def self.development?
    env == 'development'
  end
end
