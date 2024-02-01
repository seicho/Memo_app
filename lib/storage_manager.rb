# frozen_string_literal: true

require 'pg'
require_relative '../config/database'

class StorageManager
  @@conn = Database.connect :development
end
