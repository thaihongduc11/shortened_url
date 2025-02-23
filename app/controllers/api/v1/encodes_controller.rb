# frozen_string_literal: true

module Api
  module V1
    class EncodesController < ApplicationController
      def create
        result = ShortenedUrl::EncodeService.new(params[:url]).call
        if result.success
          response_json(200, 'Encode URL successfully', result.response)
        else
          response_json(400, 'Failed to encode URL', result.error_response)
        end
      end
    end
  end
end
