# frozen_string_literal: true

require 'json'

class StorageManager
  attr_accessor :path

  def initialize
    @path = "#{File.dirname(__FILE__, 2)}/memo.json"
  end

  def read
    File.open(path, 'r') do |f|
      JSON.parse(f.read, symbolize_names: true)
    end
  end

  def write(all_memos)
    File.open(path, 'w') do |f|
      f.write JSON.generate(all_memos)
    end
  end

  def user_list
    all_memos = read
    all_memos.keys
  end

  def save(user, user_memos)
    updated_all_memos = update_all_memos(user, user_memos)
    write(updated_all_memos)
  end

  def update_all_memos(user, user_memos)
    all_memos = read
    all_memos.merge(user.to_sym => user_memos)
  end
end
