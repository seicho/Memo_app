# frozen_string_literal: true

require 'pg'
require_relative '../config/database'

class StorageManager
  def initialize
    @conn = Database.connect :development
  end
end
