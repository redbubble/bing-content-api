RSpec.describe Bing::Content::Api::Batch do
  context "has products" do
    let(:product1) { build(:product) }
    let(:product2) { build(:product, offer_id: 2) }
    let(:product3) { build(:product, offer_id: 3) }
    let(:product4) { build(:product, offer_id: 4) }
    let(:product5) { build(:product, offer_id: 5) }

    subject(:batch) { Bing::Content::Api::Batch.new }

    it "starts empty" do
      expect(batch.operations).to match_array([])
    end

    it "correctly models insertion" do
      batch.add_insertions([product1])
      expect(batch.operations.length).to eq(1)
    end

    it "isn't amnesiac" do
      batch.add_insertions([product1, product2, product3])
      batch.add_deletions([product4, product5])
      expect(batch.all_products).to match_array([product1, product2, product3, product4, product5])
    end

    it "retrieves products correctly" do
      batch.add_insertions([product1, product2, product3])
      batch.add_deletions([product4, product5])
      expect(batch.product_by_batch_id(999)).to eq(product2)
    end

    it "complains on invalid batch id" do
      batch.add_insertions([product1, product2, product3])
      batch.add_deletions([product4, product5])
      expect { batch.product_by_batch_id(99) }.to raise_exception(/nil:NilClass/)
    end
  end
end
