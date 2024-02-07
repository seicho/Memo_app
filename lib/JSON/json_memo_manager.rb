# frozen_string_literal: true

require 'securerandom'

class JasonMemoManager
  attr_reader :memos

  Memo = Data.define(:title, :body)

  def initialize(user)
    @memos = memos_to_instance(StorageManager.new.read(user)) || {}
    @user = user
  end

  def add(title, body)
    new_id = SecureRandom.uuid
    memos[new_id.to_sym] = Memo.new(title, body)
    StorageManager.new.save(@user, memos_to_hash)
    new_id
  end

  def modify(id:, title:, body:)
    @memos[id.to_sym] = Memo.new(title, body)
    StorageManager.new.save(@user, memos_to_hash)
  end

  def find(id)
    @memos.each do |target_id, memo|
      return memo if target_id == id.to_sym
    end
    nil
  end

  def delete(id)
    @memos.delete(id.to_sym)
    StorageManager.new.save(@user, memos_to_hash)
  end

  private

  def memos_to_hash
    @memos.transform_values { |memo| { title: memo.title, body: memo.body } }
  end

  def memos_to_instance(memos_hash)
    memos_hash&.transform_values { |memo| Memo.new(memo[:title], memo[:body]) }
  end
end
