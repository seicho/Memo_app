# frozen_string_literal: true

require_relative './database'

class ConnectionPool
  def initialize(db)
    @connection_pool = []
    @active_connections = []
    @db = db
    5.times { @connection_pool << @db.build_connection }
  end

  def hold
    @connection_pool.push(@db.build_connection) and p('make_new connection') if @connection_pool.empty?
    @active_connections << @connection_pool.pop
    yield @active_connections.last
  end

  def checkin(connection)
    @active_connections.reject! { |conn| conn == connection }
    return if @connection_pool.count >= 5

    @connection_pool << connection
  end
end
