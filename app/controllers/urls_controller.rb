# frozen_string_literal: true

class UrlsController < ApplicationController
  def show
    url = Url.find_by(code: params[:short_url])
    return response_json(400, 'Short URL is not found') if url.blank?

    redirect_to url.redirect_url, allow_other_host: true
  end
end
