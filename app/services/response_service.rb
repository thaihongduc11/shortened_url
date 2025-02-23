# frozen_string_literal: true

module ResponseService
  extend ActiveSupport::Concern

  def fail(error)
    ServiceResult.new(success: false, response: { error: })
  end

  def success(args = {})
    ServiceResult.new(success: true, response: args)
  end
end
