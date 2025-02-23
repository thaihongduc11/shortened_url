# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::DecodesController, type: :request do
  describe 'POST #create' do
    context 'Decode Failed' do
      it 'URL not found' do
        post '/api/v1/decode', params: { url: 'https://www.example.com' }

        json = JSON.parse(response.body)

        expect(response.status).to eq(400)
        expect(json['message']).to eq('Failed to decode URL')
        expect(json['content']['errors'].first['message']).to eq('URL not found')
      end

      it 'URL is not valid' do
        post '/api/v1/decode', params: { url: 'example.com' }

        json = JSON.parse(response.body)

        expect(response.status).to eq(400)
        expect(json['message']).to eq('Failed to decode URL')
        expect(json['content']['errors'].first['message']).to eq('Invalid URL')
      end

      it 'URL is required' do
        post '/api/v1/decode', params: { url: '' }

        json = JSON.parse(response.body)

        expect(response.status).to eq(400)
        expect(json['message']).to eq('Failed to decode URL')
        expect(json['content']['errors'].first['message']).to eq('URL is required')
      end
    end

    context 'Decode Success' do
      before do
        post '/api/v1/encode', params: { url: 'https://www.example.com' }
      end

      it 'returns a success response' do
        url = Url.last
        post '/api/v1/decode', params: { url: url.short_url }

        json = JSON.parse(response.body)

        expect(response.status).to eq(200)
        expect(json['message']).to eq('Decode URL successfully')
        expect(json['content']['original_url']).to eq('https://www.example.com')
      end
    end
  end
end
