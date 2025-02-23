# frozen_string_literal: true

module ShortenedUrl
  class EncodeService < BaseService
    include ResponseService

    RETRY_COUNT = 3

    def initialize(url)
      @url = url
    end

    def call
      return fail('URL is required') if @url.blank?
      return fail('Invalid URL') unless validate_params_url?(@url)
      return fail('This URL is shortened') if shortened_url?

      existing_url = Url.find_by(original_url: @url)
      return success(short_url: existing_url.short_url) if existing_url.present?

      code = generate_code
      return fail('Failed to generate short url, please try again later') if code.blank?

      url = Url.new(original_url: @url)
      url.code = code
      url.format_url

      return fail('Failed to create URL') unless url.save

      success(short_url: url.short_url)
    end

    private

    def generate_code
      RETRY_COUNT.times do
        code = SecureRandom.alphanumeric(6)
        return code unless Url.exists?(code:)
      end

      nil
    end

    def shortened_url?
      code = @url.split('/').last

      url = Url.find_by(code:)
      return false if url.blank?

      url.short_url == @url.strip
    end
  end
end
