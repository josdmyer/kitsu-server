require 'rails_helper'

RSpec.describe Webhooks::GetstreamController, type: :controller do
  describe '#verify' do
    before { get :verify }

    it 'should return the API key' do
      expect(response.body).to eq(StreamRails.client.api_key)
    end

    it 'should return a 200 OK status' do
      expect(response).to have_http_status(:ok)
    end
  end

  describe '#notify' do
    context 'receiving feed removed notifications' do
      let(:body) { fixture('getstream_webhook/feed_remove_request.json') }

      it 'should not dispatch notification worker' do
        worker = double(OneSignalNotificationWorker)
        expect(worker).not_to receive(:perform_async)
        stub_const('OneSignalNotificationWorker', worker)
        post :notify, body
      end

      it 'should return a status of OK' do
        post :notify, body
        expect(response).to have_http_status(:ok)
      end
    end

    context 'receiving some new notification to push' do
      let(:body) { fixture('getstream_webhook/new_feed_request.json') }

      it 'should dispatch multiple notification workers' do
        worker = double(OneSignalNotificationWorker)
        expect(worker).to receive(:perform_async).exactly(7).times
        stub_const('OneSignalNotificationWorker', worker)
        post :notify, body
      end

      it 'should return a status of OK' do
        post :notify, body
        expect(response).to have_http_status(:ok)
      end
    end
  end
end
