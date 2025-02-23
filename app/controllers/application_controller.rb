# frozen_string_literal: true

class ApplicationController < ActionController::Base
  skip_before_action :verify_authenticity_token

  def response_json(code, message, content = {})
    response = { message: }
    response[:content] = content if content.present?

    render json: response, status: code
  end
end
