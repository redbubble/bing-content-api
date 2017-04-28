RSpec.describe Bing::Content::Api::BatchOperation do
  let(:product1) { build(:product) }
  let(:batchid) { 1 }

  describe "#initialize" do
  subject(:batchop) { Bing::Content::Api::BatchOperation }
    it "rejects invalid operations" do
      expect { batchop.new(1, product1, :foo) }.to raise_error(/select a valid operation/)
    end
  end

  subject { Bing::Content::Api::BatchOperation.new(batchid, product1, operation).bing_operation }

  describe "#bing_operation" do
    context "insert job" do
      let(:operation) { :insert }

      it "has the correct batch id" do
        expect(subject[:batchId]).to eq(1)
      end
      it "has the correct operation type" do
        expect(subject[:method]).to eq("insert")
      end
      it "has a product" do
        expect(subject[:product]).not_to be_nil
      end
    end
    context "delete job" do
      let(:operation) { :delete }

      it "has the correct batch id" do
        expect(subject[:batchId]).to eq(1)
      end
      it "has the correct operation type" do
        expect(subject[:method]).to eq("delete")
      end
      it "has no product" do
        expect(subject[:product]).to be_nil
      end
      it "has a product id" do
        expect(subject[:productId]).to eq(product1.bing_product_id)
      end
    end
  end
end
