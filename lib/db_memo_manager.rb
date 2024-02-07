# frozen_string_literal: true

require_relative './database'
require_relative './memo_manager'

class DbMemoManager
  include MemoManager

  def initialize(db)
    @db = db
  end

  def read(user_id)
    res = @db.query(
      'SELECT memos.id, memos.title, memos.body FROM memos WHERE user_id = $1', [user_id]
    )
    user_memos = {}
    res.each do |row|
      user_memos[row[:id]] = { title: row[:title], body: row[:body] }
    end
    user_memos
  end

  def create(user_id:, title:, body:)
    res = @db.query(
      'INSERT iNTO memos (user_id, title, body) VALUES ($1, $2, $3)', [user_id, title, body]
    )
    !res.cmd_tuples.zero?
  end

  def update(id:, title:, body:)
    res = @db.query(
      'UPDATE memos SET title = $1, body = $2 WHERE id = $3', [title, body, id]
    )
    !res.cmd_tuples.zero?
  end

  def delete(target_id)
    res = @db.query(
      'DELETE FROM memos WHERE id = $1', [target_id]
    )
    !res.cmd_tuples.zero?
  end

  def latest_id
    res = @db.query(
      'SELECT id FROM memos ORDER BY id DESC LIMIT 1'
    )
    res.getvalue(0, 0)
  end

  def find(user_id, target_memo_id)
    res = @db.query(
      'SELECT body, title FROM memos WHERE user_id = $1 AND id = $2', [user_id, target_memo_id]
    )
    return nil if res.ntuples.zero?

    res[0] # return memo title and body as hash.
  end
end
