require 'json'

class Memo
  attr_reader :title, :body
  
  def initialize(title, body)
    @title = title
    @body = body
  end
end

class MemoManager
  include Enumerable
  attr_accessor :memos, :controler, :user

  def initialize(user_memos, user, controler)
    @memos = user_memos
    @controler = controler
    @user = user
  end

  def each
    memos.each do |id, memos|
      yield id, memos.title, memos.body if block_given?
    end
  end

  def add_memo(title, body)
    memos[new_id] = Memo.new(title, body)
    controler.save(user, memos)
  end

  def max_id
    memos.keys.map{ |k| k.to_s.to_i }.max
  end

  def new_id
    memos.empty? ? "1".to_sym : (max_id + 1).to_s.to_sym
  end

  def modify_memo(id, title, body)
    memos[id.to_sym] = Memo.new(title, body)
    controler.save(user, memos)
  end

  def find_memo(id)
    memos.each do |target_id, memo|
      return memo if target_id == id.to_sym
    end
    nil
  end
  
  def delete_memo(id)
    memos.delete(id.to_sym)
    controler.save(user, memos)
  end
end

class Controler
  attr_accessor :all_memos, :storage_manager
  def initialize
    @storage_manager = StorageManager.new
    @all_memos = {}
  end

  def generate_memo_manager(user)
    open_all_memos
    user = user.to_sym
    !user_exist?(user) && create_user_space(user) 
    MemoManager.new(all_memos[user], user, self)
  end

  def open_all_memos
    base_data = storage_manager.open
    base_data.each do |user, memos|
      all_memos[user] = {}
      memos.each do |id, memo|
        all_memos[user][id] = Memo.new(memo[:title], memo[:body])
      end
    end
  end

  def user_exist?(user)
    all_memos.has_key?(user)
  end

  def create_user_space(user)
    all_memos[user] = {}
  end
  
  def save(user, memo)
    update_all_memos(user, memo)
    storage_manager.write(formatted_all_memos)
  end

  def update_all_memos(user, memo)
    all_memos[user.to_sym] = memo
  end

  def formatted_all_memos
    all_memos.map do |user, memos|
      converted_memos = memos.map do |id, memo| 
          [id, {:title=> memo.title, :body=> memo.body}]
        end.to_h
      [user,converted_memos]
    end.to_h
  end
end

class StorageManager
  attr_accessor :path
  def initialize
    @path = "#{File.dirname(__FILE__, 2)}/memo.json"
  end

  def open
    File.open(path, 'r') do |f|
      JSON.parse(f.read, symbolize_names: true)
    end
  end

  def write(all_memos)
    File.open(path, 'w') do |f|
      f.write JSON.generate(all_memos)
    end
  end
end
