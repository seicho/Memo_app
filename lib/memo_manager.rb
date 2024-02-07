# frozen_string_literal: true

require_relative './database'

class MemoManager
  def read(*)
    raise NotImplementedError,
          "This #{self.class} cannot respond to"
  end

  def save(*)
    raise NotImplementedError,
          "This #{self.class} cannot respond to"
  end

  def update(*)
    raise NotImplementedError,
          "This #{self.class} cannot respond to"
  end

  def delete(*)
    raise NotImplementedError,
          "This #{self.class} cannot respond to"
  end

  def latest_id(*)
    raise NotImplementedError,
          "This #{self.class} cannot respond to"
  end

  def find(*)
    raise NotImplementedError,
          "This #{self.class} cannot respond to"
  end
end
