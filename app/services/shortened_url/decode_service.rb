# frozen_string_literal: true

module ShortenedUrl
  class DecodeService < BaseService
    include ResponseService

    def initialize(url)
      @url = url
      @code = url.split('/').last
    end

    def call
      return fail('URL is required') if @code.blank?
      return fail('Invalid URL') unless validate_params_url?(@url)

      url = Url.find_by(code: @code)
      return success(original_url: url.original_url) if url.present?

      fail('URL not found')
    end
  end
end
