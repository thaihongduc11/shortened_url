# frozen_string_literal: true

module Api
  module V1
    class DecodesController < ApplicationController
      def create
        result = ShortenedUrl::DecodeService.new(params[:url]).call
        if result.success
          response_json(200, 'Decode URL successfully', result.response)
        else
          response_json(400, 'Failed to decode URL', result.error_response)
        end
      end
    end
  end
end
