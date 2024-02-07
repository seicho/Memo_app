# frozen_string_literal: true

require_relative './database'
require_relative './user_manager'

class UserManager
  def find(username)
    raise 'Implement me'
  end

  def create(username)
    raise 'Implement me'
  end
end
