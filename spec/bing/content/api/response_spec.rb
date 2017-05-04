RSpec.describe Bing::Content::Api::Response do
  context "has products" do
    let(:batch) { Bing::Content::Api::Batch.new }
    let(:product) { build(:product) }

    it "starts with empty successes" do
      response = described_class.new([], batch)
      expect(response.successes).to eq([])
    end

    it "starts with empty failures" do
      response = described_class.new([], batch)
      expect(response.failures).to eq([])
    end

    describe "#initialize" do
      subject(:response) { described_class.new(response_entries, batch) }

      let(:batch) do
        Bing::Content::Api::Batch.new.tap do |b|
          b.add_insertions([product])
        end
      end

      context "valid product, successful insertion" do
        let(:response_entries) { [{"batchId" => "1000", "product" => product.to_record }] }

        it "correctly categorises a success" do
          expect(response.successes.first[:product]).to eq(product)
        end

        it "on success failures list is empty" do
          expect(response.failures).to eq([])
        end

      end

      context "invalid product, cannot insert" do
        let(:product) { build(:product, condition: nil) }
        let(:response_entries) do
          [{"kind" => "content#productsCustomBatchResponseEntry",
            "batchId" => "1000",
            "method" => "insert",
            "errors" =>
              {"errors" =>
               [{"reason" => "validation",
                 "message" => "[condition] validation/missing_required for AffiliateNetwork,DisplayAds,Shopping,ShoppingApi,ShoppingExpress: Missing required attribute: condition",
                 "domain" => "content.ContentErrorDomain"}],
               "code" => "400",
               "message" => "[condition] validation/missing_required for AffiliateNetwork,DisplayAds,Shopping,ShoppingApi,ShoppingExpress: Missing required attribute: condition"}}]
        end

        it "correctly categorises a failure" do
          expect(response.failures.first).to eq(response: response_entries.first,
                                                product: product)

        end
        it "has no spurious successes" do
          expect(response.successes).to eq([])
        end
      end
    end
  end
end
