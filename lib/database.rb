# frozen_string_literal: true

require 'config'

module Database
  Config.load_and_set_settings("#{File.dirname(__FILE__, 2)}/config/settings.yml")
  def self.connect(env)
    db_config = Settings.__send__ env
    connection = PG.connect(
      dbname: db_config[:dbname],
      host: db_config[:host],
      port: db_config[:port],
      user: db_config[:user],
      password: db_config[:password]
    )
    connection.field_name_type = :symbol
    connection
  end
end
