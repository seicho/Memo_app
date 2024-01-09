# frozen_string_literal: true

require 'securerandom'

class MemoManager
  include Enumerable
  attr_accessor :memos, :storage_manager, :user

  def initialize(user)
    @storage_manager = StorageManager.new
    all_memos = storage_manager.read
    user_memos = storage_manager.user_list.include?(user) ? all_memos[user].transform_values { |memo| Memo.new(memo[:title], memo[:body]) } : {}
    @memos = user_memos
    @user = user
  end

  def each
    memos.each do |id, memos|
      yield id, memos.title, memos.body if block_given?
    end
  end

  def add(title, body)
    new_id = SecureRandom.uuid
    memos[new_id.to_sym] = Memo.new(title, body)
    storage_manager.save(user, memos_to_hash)
    new_id
  end

  def modify(id, title, body)
    memos[id.to_sym] = Memo.new(title, body)
    storage_manager.save(user, memos_to_hash)
  end

  def find(id)
    memos.each do |target_id, memo|
      return memo if target_id == id.to_sym
    end
    nil
  end

  def delete(id)
    memos.delete(id.to_sym)
    storage_manager.save(user, memos_to_hash)
  end

  def memos_to_hash
    memos.transform_values { |memo| { title: memo.title, body: memo.body } }
  end
end
