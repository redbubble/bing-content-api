RSpec.describe Bing::Content::Api::Response do
  context "has products" do
    let(:product1) { build(:product, offer_id: "1") }
    let(:product2) { build(:product, offer_id: "2") }
    let(:product3) { build(:product, offer_id: "3") }
    let(:batch) { Bing::Content::Api::Batch.new }

    it "starts with empty responses" do
      response = described_class.new([], batch)
      expect(response.instance_variable_get(:@successes)).to eq([])
      expect(response.instance_variable_get(:@failures)).to eq([])
    end

    it "initially considers all jobs failed" do
      batch.add_insertions([product1, product2, product3])
      response = described_class.new([], batch)
      expect(response.instance_variable_get(:@successes)).to eq([])
      expect(response.instance_variable_get(:@failures)).to match_array([product1, product2, product3])
    end

    it "sets jobs to succeeded one-by-one" do
      batch.add_insertions([product1, product2, product3])
      response = described_class.new([], batch)
      response.add_success(product1)
      expect(response.instance_variable_get(:@successes)).to match_array([product1])
      expect(response.instance_variable_get(:@failures)).to match_array([product2, product3])
    end

    it "is successful when all products are done" do
      batch.add_insertions([product1, product2, product3])
      response = described_class.new([], batch)
      response.add_success(product3)
      response.add_success(product2)
      response.add_success(product1)
      expect(response.instance_variable_get(:@successes)).to match_array([product1, product2, product3])
      expect(response.instance_variable_get(:@failures)).to match_array([])
    end
  end
end
