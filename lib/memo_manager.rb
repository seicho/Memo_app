# frozen_string_literal: true

require_relative './database'

class MemoManager
  def read(user_id)
    raise NotImpementedError,
          "This #{self.class} cannot respond to"
  end

  def save(user_id:, title:, body:)
    raise NotImpementedError,
          "This #{self.class} cannot respond to"
  end

  def update(id:, title:, body:)
    raise NotImpementedError,
          "This #{self.class} cannot respond to"
  end

  def delete(target_id)
    raise NotImpementedError,
          "This #{self.class} cannot respond to"
  end

  def latest_id
    raise NotImpementedError,
          "This #{self.class} cannot respond to"
  end

  def find(user_id, target_id)
    raise NotImpementedError,
          "This #{self.class} cannot respond to"
  end
end
