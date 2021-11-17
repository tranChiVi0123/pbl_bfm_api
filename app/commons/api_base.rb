# frozen_string_literal: true

class ApiBase
  def self.call(*args, &block)
    new.call(*args, &block)
  end
end
