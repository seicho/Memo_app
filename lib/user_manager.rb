# frozen_string_literal: true

require_relative './storage_manager'

class UserManager < StorageManager
  def self.find_user(username)
    res = @@conn.exec(
      'SELECT id FROM users WHERE username = $1', [username]
    )
    return nil if res.ntuples.zero?

    res[0][:id] # return user_id
  end

  def self.create_user(username)
    @@conn.exec(
      'INSERT INTO users (username) VALUES ($1)', [username]
    )
    find_user(username) # return user_id
  end
end
