# frozen_string_literal: true

require 'pg'
require 'config'

class Database
  def initialize
    Config.load_and_set_settings("#{File.dirname(__FILE__, 2)}/config/settings.yml")
    @env = :development
    @db_config = Settings.public_send @env
    @conn = build_connection
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
    @conn.exec(sqls, var)
  end
end
