# frozen_string_literal: true

require_relative './storage_manager'

class MemoManager < StorageManager
  def read(user_id)
    res = @conn.exec(
      'SELECT memos.id, memos.title, memos.body FROM memos WHERE user_id = $1', [user_id]
    )
    user_memos = {}
    res.each do |row|
      user_memos[row[:id]] = { title: row[:title], body: row[:body] }
    end
    user_memos
  end

  def save(user_id:, title:, body:)
    res = @conn.exec(
      'INSERT iNTO memos (user_id, title, body) VALUES ($1, $2, $3)', [user_id, title, body]
    )
    !res.cmd_tuples.zero?
  end

  def update(id:, title:, body:)
    res = @conn.exec(
      'UPDATE memos SET title = $1, body = $2 WHERE id = $3', [title, body, id]
    )
    !res.cmd_tuples.zero?
  end

  def delete(target_id)
    res = @conn.exec(
      'DELETE FROM memos WHERE id = $1', [target_id]
    )
    !res.cmd_tuples.zero?
  end

  def latest_id
    res = @conn.exec(
      'SELECT id FROM memos ORDER BY id DESC LIMIT 1'
    )
    res.getvalue(0, 0)
  end

  def find_by(user_id, target_id)
    res = @conn.exec(
      'SELECT body, title FROM memos WHERE user_id = $1 AND id = $2', [user_id, target_id]
    )
    return nil if res.ntuples.zero?

    res[0] # return memo title and body as hash.
  end
end
