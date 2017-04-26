RSpec.describe Bing::Content::Api::Product do
  context "has a valid product" do
    let(:product) { build(:product) }

    it "returns a sane product hash" do
      expect(product.to_record).to eq({
       "availability" => "in stock",
       "channel" => "online",
       "condition" => "new",
       "contentLanguage" => "en",
       "description" => "this is the best sticker in the world",
       "imageLink" => "https://ih1.redbubble-staging.net/image.7202580.1759/sticker,375x360-bg,ffffff.jpg",
       "link" => "https://www.redbubble-staging.com/people/toothbrush/works/3051759-a-thing-a-church?p=sticker&size=small",
       "offerId" => "3051759-US-sticker",
       "price" => {"currency" => "USD", "value" => 6.66},
       "targetCountry" => "US",
       "title" => "Awesome sticker",
      })
    end

    it "builds a sane Bing id" do
      expect(product.bing_product_id).to eq("online:en:US:3051759-US-sticker")
    end
  end
end
