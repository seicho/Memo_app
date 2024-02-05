# frozen_string_literal: true

require 'pg'
require_relative './database'

class StorageManager
  def initialize
    @conn = Database.connect :development
  end
end
