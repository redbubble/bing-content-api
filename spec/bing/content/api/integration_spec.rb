RSpec.describe Bing::Content::Api::Client do

  context "has valid refresh_token" do
    let(:application_id) { "app_id_foo" }
    let(:developer_token) { "dev_token_foo" }
    let(:merchant_id) { "123" }
    let(:auth) { "refresh_token" }

    let(:product) { build(:product) }

    subject(:bing_client) {
      Bing::Content::Api::Client.new(
        application_id,
        developer_token,
        merchant_id,
        refresh_token=auth) }

    it "successfully inserts a product into the catalog" do
      VCR.use_cassette("insert-product-integration") do
        batch = Bing::Content::Api::Batch.new
        batch.add_insertions([product])

        bing_client.run_batch(batch)

        catalogue = bing_client.retrieve_catalogue
        expected_product = product.to_record
        expect(catalogue.length).to eq(1)
        catalogue_product = catalogue[0]

        expected_product.each do |key, val|
          expect(catalogue_product[key]).to eq(val)
        end
      end
    end
  end
end
