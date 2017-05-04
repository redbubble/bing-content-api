RSpec.describe Bing::Content::Api::BatchOperation do
  subject(:bing_operation) { described_class.new(batchid, product1, operation).bing_operation }

  let(:product1) { build(:product) }
  let(:batchid) { 1 }

  describe "#initialize" do
    it "rejects invalid operations" do
      expect { described_class.new(1, product1, :foo) }.to raise_error(/select a valid operation/)
    end
  end

  describe "#bing_operation" do
    context "insert job" do
      let(:operation) { :insert }

      it "has the correct batch id" do
        expect(bing_operation[:batchId]).to eq(1)
      end
      it "has the correct operation type" do
        expect(bing_operation[:method]).to eq("insert")
      end
      it "has a product" do
        expect(bing_operation[:product]).not_to be_nil
      end
    end
    context "delete job" do
      let(:operation) { :delete }

      it "has the correct batch id" do
        expect(bing_operation[:batchId]).to eq(1)
      end
      it "has the correct operation type" do
        expect(bing_operation[:method]).to eq("delete")
      end
      it "has no product" do
        expect(bing_operation[:product]).to be_nil
      end
      it "has a product id" do
        expect(bing_operation[:productId]).to eq(product1.bing_product_id)
      end
    end
  end
end
