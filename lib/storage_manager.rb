# frozen_string_literal: true

require 'json'

class StorageManager
  def initialize
    @path = "#{File.dirname(__FILE__, 2)}/memo.json"
  end

  def read(user)
    read_all[user.to_sym]
  end

  def read_all
    File.open(@path, 'r') do |f|
      JSON.parse(f.read, symbolize_names: true)
    end
  end

  def write(all_memos)
    File.open(@path, 'w') do |f|
      f.write JSON.generate(all_memos)
    end
  end

  def user_list
    all_memos = read_all
    all_memos.keys
  end

  def save(user, latest_user_memos)
    all_memos = read_all
    all_memos[user.to_sym] = latest_user_memos
    write all_memos
  end
end
