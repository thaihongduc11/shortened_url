# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::EncodesController, type: :request do
  describe 'POST #create' do
    context 'Encode Failed' do
      it 'URL is not valid' do
        post '/api/v1/encode', params: { url: 'example.com' }

        json = JSON.parse(response.body)

        expect(response.status).to eq(400)
        expect(json['message']).to eq('Failed to encode URL')
        expect(json['content']['errors'].first['message']).to eq('Invalid URL')
      end

      it 'URL is required' do
        post '/api/v1/encode', params: { url: '' }

        json = JSON.parse(response.body)

        expect(response.status).to eq(400)
        expect(json['message']).to eq('Failed to encode URL')
        expect(json['content']['errors'].first['message']).to eq('URL is required')
      end

      context 'URL is shortened' do
        let(:url) do
          Url.create(original_url: 'http://example.com/',
                     code: 'abc',
                     redirect_url: 'http://example.com/abc123456',
                     short_url: 'http://example.com/abc')
        end

        it 'URL is shortened' do
          post '/api/v1/encode', params: { url: url.short_url }

          json = JSON.parse(response.body)

          expect(response.status).to eq(400)
          expect(json['message']).to eq('Failed to encode URL')
          expect(json['content']['errors'].first['message']).to eq('This URL is shortened')
        end
      end

      context 'Failed to generate short url' do
        before do
          allow(SecureRandom).to receive(:alphanumeric).and_return('dup123', 'dup123', 'dup123')
          allow(Url).to receive(:exists?).with(code: 'dup123').and_return(true)
        end

        it 'returns a failure response' do
          post '/api/v1/encode', params: { url: 'https://www.example.com' }

          json = JSON.parse(response.body)
          response_text = 'Failed to generate short url, please try again later'

          expect(response.status).to eq(400)
          expect(json['message']).to eq('Failed to encode URL')
          expect(json['content']['errors'].first['message']).to eq(response_text)
        end
      end
    end

    context 'Encode Success' do
      it 'returns a success response' do
        post '/api/v1/encode', params: { url: 'https://www.example.com' }

        json = JSON.parse(response.body)

        expect(response.status).to eq(200)
        expect(json['message']).to eq('Encode URL successfully')
        expect(json['content']['short_url']).not_to be_nil
      end
    end
  end
end
