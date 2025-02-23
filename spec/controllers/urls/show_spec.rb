# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UrlsController, type: :controller do
  describe 'GET #show' do
    let(:original_url) { 'http://example.com/abc123456' }
    let(:code) { 'abc123' }
    let(:valid_short_url) { 'http://example.ly/abc123' }
    let(:redirect_url) { 'http://example.com' }
    let!(:url) do
      Url.create(original_url:, code:, redirect_url:, short_url: valid_short_url)
    end

    it 'redirects to the original URL' do
      get :show, params: { short_url: code }

      expect(response.status).to eq(302)
      expect(response).to redirect_to(redirect_url)
    end

    it 'returns an error response' do
      get :show, params: { short_url: 'http://example.ly/unknown' }

      json = JSON.parse(response.body)
      expect(response.status).to eq(400)
      expect(json['message']).to eq('Short URL is not found')
    end
  end
end
