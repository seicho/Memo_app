# frozen_string_literal: true

require 'pg'
require_relative './database'

class DatabaseManager
  def initialize
    @conn = Database.connect :development
  end
end
