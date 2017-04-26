RSpec.describe Bing::Content::Api::BatchOperation do
  context "has products" do
    let(:product1) { build(:product) }

    subject(:batchop) { Bing::Content::Api::BatchOperation }

    it "rejects invalid operations" do
      expect { batchop.new(1, product1, :foo) }.to raise_error(/select a valid operation/)
    end

    it "produces a sane delete job" do
      expect(batchop.new(1, product1, :delete).bing_operation).to eq({
        :batchId => 1,
        :method => "delete",
        :productId => "online:en:US:3051759-US-sticker",
      })
    end

    it "produces a sane insert job" do
      expect(batchop.new(1, product1, :insert).bing_operation).to eq({
        :batchId => 1,
        :method => "insert",
        :product => {
          "offerId" => "3051759-US-sticker",
          "title" => "Awesome sticker",
          "description" => "this is the best sticker in the world",
          "price" => { "currency" => "USD", "value" => 6.66 },
          "imageLink" => "https://ih1.redbubble-staging.net/image.7202580.1759/sticker,375x360-bg,ffffff.jpg",
          "link" => "https://www.redbubble-staging.com/people/toothbrush/works/3051759-a-thing-a-church?p=sticker&size=small",
          "targetCountry" => "US",
          "contentLanguage" => "en",
          "availability" => "in stock",
          "channel" => "online",
          "condition" => "new"},
      })
    end
  end
end
