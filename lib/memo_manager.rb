# frozen_string_literal: true

require 'securerandom'

class MemoManager
  attr_reader :memos

  Memo = Struct.new(:title, :body)

  def initialize(user)
    users = storage_manager.user_list
    @memos = users.include?(user.to_sym) ? memos_to_instance(storage_manager.read(user)) : {}
    @user = user
  end

  def add(title, body)
    new_id = SecureRandom.uuid
    memos[new_id.to_sym] = Memo.new(title, body)
    storage_manager.save(@user, memos_to_hash)
    new_id
  end

  def modify(id, title, body)
    @memos[id.to_sym] = Memo.new(title, body)
    storage_manager.save(@user, memos_to_hash)
  end

  def find(id)
    @memos.each do |target_id, memo|
      return memo if target_id == id.to_sym
    end
    nil
  end

  def delete(id)
    @memos.delete(id.to_sym)
    storage_manager.save(@user, memos_to_hash)
  end

  private

  def storage_manager
    StorageManager.new
  end

  def memos_to_hash
    @memos.transform_values { |memo| { title: memo.title, body: memo.body } }
  end

  def memos_to_instance(memos_hash)
    memos_hash.transform_values { |memo| Memo.new(memo[:title], memo[:body]) }
  end
end
