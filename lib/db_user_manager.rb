# frozen_string_literal: true

require_relative './database'
require_relative './user_manager'

class DbUserManager
  include UserManager

  def initialize(db)
    @db = db
  end

  def find(username)
    res = @db.query(
      'SELECT id FROM users WHERE username = $1', [username]
    )
    return nil if res.ntuples.zero?

    res[0][:id] # return user_id
  end

  def create(username)
    @db.query(
      'INSERT INTO users (username) VALUES ($1)', [username]
    )
    find(username) # return user_id
  end
end
