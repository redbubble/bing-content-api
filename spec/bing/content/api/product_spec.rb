RSpec.describe Bing::Content::Api::Product do

  describe "#to_record" do

    subject { product.to_record }
    let(:product) { build(:product) }

    it "has a title" do
      expect(subject["title"]).to eq(product.title)
    end

    it "has a description" do
      expect(subject["description"]).to eq(product.description)
    end

    it "has an availability" do
      expect(subject["availability"]).to eq(product.availability)
    end

    it "has an offer id" do
      expect(subject["offerId"]).to eq(product.offer_id)
    end

    it "has a currency" do
      expect(subject["price"]["currency"]).to eq(product.currency)
    end

    it "has a price value" do
      expect(subject["price"]["value"]).to eq(product.price)
    end

    it "has an image link" do
      expect(subject["imageLink"]).to eq(product.image_link)
    end

    it "has a product link" do
      expect(subject["link"]).to eq(product.product_link)
    end

    it "has a target country" do
      expect(subject["targetCountry"]).to eq(product.target_country)
    end

    it "has a content language" do
      expect(subject["contentLanguage"]).to eq(product.content_language)
    end

    it "has a channel" do
      expect(subject["channel"]).to eq(product.channel)
    end

    it "has a condition" do
      expect(subject["condition"]).to eq(product.condition)
    end

    it "has a product type" do
      expect(subject["productType"]).to eq(product.product_type)
    end

    it "has a product category" do
      expect(subject["productCategory"]).to eq(product.product_category)
    end
  end

  describe "#bing_product_id" do
    let(:product) do
      build(:product,
        channel: "online",
        content_language: "en",
        target_country: "US",
        offer_id: "3051759-US-sticker")
    end
    subject { product.bing_product_id }

    it "builds a sane Bing id" do
      expect(subject).to eq("online:en:US:3051759-US-sticker")
    end
  end
end
