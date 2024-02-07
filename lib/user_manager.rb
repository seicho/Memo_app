# frozen_string_literal: true

require_relative './database'
require_relative './user_manager'

module UserManager
  def find(*)
    raise NotImplementedError,
          "This #{self.class} cannot respond to"
  end

  def create(*)
    raise NotImplementedError,
          "This #{self.class} cannot respond to"
  end
end
