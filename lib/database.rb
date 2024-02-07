# frozen_string_literal: true

require 'pg'
require 'config'
require_relative './connection_pool'

class Database
  def initialize
    Config.load_and_set_settings("#{File.dirname(__FILE__, 2)}/config/settings.yml")
    @env = :development
    @db_config = Settings.__send__ @env
    @pool = ConnectionPool.new(self)
  end

  def build_connection
    connection = PG.connect(
      dbname: @db_config[:dbname],
      host: @db_config[:host],
      port: @db_config[:port],
      user: @db_config[:user],
      password: @db_config[:password]
    )
    connection.field_name_type = :symbol
    connection
  end

  def query(sqls, var = nil)
    res = nil
    @pool.hold do |conn|
      res = conn.exec(sqls, var)
      @pool.checkin(conn)
    end
    res
  end
end
