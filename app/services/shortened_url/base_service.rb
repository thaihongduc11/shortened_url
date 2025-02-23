# frozen_string_literal: true

module ShortenedUrl
  class BaseService
    def validate_params_url?(url)
      url.match?(URI::DEFAULT_PARSER.make_regexp(%w[http https]))
    end
  end
end
