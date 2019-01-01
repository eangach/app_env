require_relative 'lib/app_env'
AppEnv.load_dotenv

AppEnv.require_keys('DATABASE_URL')
require_relative 'lib/app_env/db/rake_tasks'
