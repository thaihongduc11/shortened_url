# frozen_string_literal: true

class Url < ApplicationRecord
  validates :original_url, presence: true, uniqueness: true
  validates :original_url,
            format: { with: URI::DEFAULT_PARSER.make_regexp(%w[http https]) },
            if: -> { original_url.present? }
  validates :code, presence: true, uniqueness: true
  validates :short_url, presence: true, uniqueness: true
  validates :redirect_url, presence: true, uniqueness: true

  def format_url
    original_url.strip!

    url = original_url.downcase.gsub(%r{(https?://|(www\.))}, '')
    self.redirect_url = "#{Settings.protocol}://#{url}"
    self.short_url = "#{Settings.protocol}://#{Settings.host}/#{code}"
  end
end
