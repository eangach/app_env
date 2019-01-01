# Load dotenv files depending on enviornment set in ENV['APP_ENV'].

module AppEnv
  class << self
  end

  class Error < StandardError; end

  class MissingKeys < Error # :nodoc:
    def initialize(keys)
      key_word = "key#{keys.size > 1 ? 's' : ''}"
      super("Missing required configuration #{key_word}: #{keys.inspect}")
    end
  end

  module_function

  def root
    ENV['APP_ROOT'] ? Pathname(ENV['APP_ROOT']) : Pathname.new(Dir.pwd)
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

  def require_keys(*keys)
    missing_keys = keys.flatten - ::ENV.keys
    return if missing_keys.empty?
    raise MissingKeys, missing_keys
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
