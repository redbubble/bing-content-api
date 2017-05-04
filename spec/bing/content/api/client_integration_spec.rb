RSpec.describe Bing::Content::Api::Client do

  context "has valid refresh_token" do
    subject(:bing_client) do
      described_class.new(application_id,
                          developer_token,
                          merchant_id,
                          auth)
    end

    let(:application_id) { "app_id_foo" }
    let(:developer_token) { "dev_token_foo" }
    let(:merchant_id) { "123" }
    let(:auth) { "refresh_token" }
    let(:product) do
      build(:product,
            offer_id: "3051759-US-sticker",
            title: "Awesome sticker",
            description: "this is the best sticker in the world",
            price: 6.66,
            currency: "USD",
            product_link: "https://www.redbubble-staging.com/people/toothbrush/works/3051759-a-thing-a-church?p=sticker&size=small",
            image_link: "https://ih1.redbubble-staging.net/image.7202580.1759/sticker,375x360-bg,ffffff.jpg",
            target_country: "US",
            content_language: "en",
            availability: "in stock",
            channel: "online",
            condition: "new")
    end

    it "contains exactly one product after insertion" do
      VCR.use_cassette("insert-product-integration") do
        batch = Bing::Content::Api::Batch.new
        batch.add_insertions([product])

        bing_client.run_batch(batch)

        catalogue = bing_client.retrieve_catalogue
        expect(catalogue.length).to eq(1)
      end
    end

    it "successfully inserts a product into the catalog" do
      VCR.use_cassette("insert-product-integration") do
        batch = Bing::Content::Api::Batch.new
        batch.add_insertions([product])

        bing_client.run_batch(batch)

        catalogue = bing_client.retrieve_catalogue
        expected_product = product.to_record
        catalogue_product = catalogue[0]

        %w[offer_id title description price product_link image_link target_country content_language availability channel condition].each do |key|
          expect(catalogue_product[key]).to eq(expected_product[key])
        end
      end
    end
  end
end
