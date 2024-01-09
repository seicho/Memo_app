# frozen_string_literal: true

require 'json'

class Memo
  attr_reader :title, :body

  def initialize(title, body)
    @title = title
    @body = body
  end
end
