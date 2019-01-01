require 'uri'

module AppEnv
  module DB
    class Config
      attr_accessor :adapter, :host, :port, :user, :password, :database

      def initialize(url=ENV['DATABASE_URL'], user=ENV['DATABASE_USER'], password=ENV['DATABASE_PASSWORD'])
        uri = URI.parse(url)
        @adapter = uri.scheme
        @host = uri.host
        @port = uri.port
        @user = ENV['DATABASE_USER'] || uri.user
        @password = ENV['DATABASE_PASSWORD'] || uri.password
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
  end
end
