RSpec.describe Bing::Content::Api::Response do
  context "has products" do
    let(:product1) { build(:product, offer_id: "1") }
    let(:product2) { build(:product, offer_id: "2") }
    let(:product3) { build(:product, offer_id: "3") }

    it "starts with empty responses" do
      response = Bing::Content::Api::Response.new
      expect(response.instance_variable_get(:@successes)).to eq([])
      expect(response.instance_variable_get(:@failures)).to eq([])
    end

    it "initially considers all jobs failed" do
      response = Bing::Content::Api::Response.new
      response.set_all_products([product1, product2, product3])
      expect(response.instance_variable_get(:@successes)).to eq([])
      expect(response.instance_variable_get(:@failures)).to match_array([product1, product2, product3])
    end

    it "sets jobs to succeeded one-by-one" do
      response = Bing::Content::Api::Response.new
      response.set_all_products([product1, product2, product3])
      response.add_success(product1)
      expect(response.instance_variable_get(:@successes)).to match_array([product1])
      expect(response.instance_variable_get(:@failures)).to match_array([product2, product3])
    end

    it "is successful when all products are done" do
      response = Bing::Content::Api::Response.new
      response.set_all_products([product1, product2, product3])
      response.add_success(product3)
      response.add_success(product2)
      response.add_success(product1)
      expect(response.instance_variable_get(:@successes)).to match_array([product1, product2, product3])
      expect(response.instance_variable_get(:@failures)).to match_array([])
    end
  end
end
