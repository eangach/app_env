# Load dotenv files depending on enviornment set in ENV['APP_ENV'].

module AppEnv
  class << self
  end

  module_function

  def root
    Pathname.new(Dir.pwd)
  end

  def env
    ENV['APP_ENV'] || ENV['RACK_ENV'] || 'development'
  end

  def dotenv_files
    [
      root.join(".env.#{env}.local"),
      (root.join(".env.local") unless env == 'test'),
      root.join(".env.#{env}"),
      root.join(".env")
    ].compact
  end

  def load_dotenv
    require 'dotenv'
    Dotenv.load(*dotenv_files)
  end

  def production?
    env == 'production'
  end

  def test?
    env == 'test'
  end

  def development?
    env == 'development'
  end
end
