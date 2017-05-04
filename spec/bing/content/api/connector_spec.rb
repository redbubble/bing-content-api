RSpec.describe Bing::Content::Api::Connector do

  let(:developer_token) { "dev_token_foo" }
  let(:token) { "token_foo" }
  let(:merchant_id) { "123" }
  let(:catalogue_id) { nil }
  let(:product) { build(:product) }
  let(:bing_connector) do
    described_class.new(
      developer_token,
      token,
      merchant_id,
      catalogue_id
    )
  end

  context "has valid refresh_token" do
    it "successfully performs a GET request" do
      VCR.use_cassette("test-get") do
        expect(bing_connector.get('/products').body).to match(/content#productsListResponse/)
      end
    end

    it "successfully performs a POST request" do
      VCR.use_cassette("test-post") do
        expect(bing_connector.post('/products/batch', "{\"entries\": [] }").body).to match(/content#productsCustomBatchResponse/)
      end
    end

    it "returns a correct base_uri" do
      expect(bing_connector.send(:base_uri)).to eq("/shopping/v9.1/bmc/#{merchant_id}")
    end
  end

  context "has non-default catalogue id" do
    let(:catalogue_id) { "789" }

    it "uses correct BMC URL parameter for POST" do
      VCR.use_cassette("test-catalogue-id") do
        expect(bing_connector.post('/products/batch', "{\"entries\": [] }").body).to match(/content#productsCustomBatchResponse/)
      end
    end
  end
end
