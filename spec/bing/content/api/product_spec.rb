RSpec.describe Bing::Content::Api::Product do
  describe "#to_record" do
    subject(:record) { product.to_record }

    let(:product) { build(:product) }

    it "has a title" do
      expect(record["title"]).to eq(product.title)
    end

    it "has a description" do
      expect(record["description"]).to eq(product.description)
    end

    it "has an availability" do
      expect(record["availability"]).to eq(product.availability)
    end

    it "has an offer id" do
      expect(record["offerId"]).to eq(product.offer_id)
    end

    it "has a currency" do
      expect(record["price"]["currency"]).to eq(product.currency)
    end

    it "has a price value" do
      expect(record["price"]["value"]).to eq(product.price)
    end

    it "has an image link" do
      expect(record["imageLink"]).to eq(product.image_link)
    end

    it "has a product link" do
      expect(record["link"]).to eq(product.product_link)
    end

    it "has a target country" do
      expect(record["targetCountry"]).to eq(product.target_country)
    end

    it "has a content language" do
      expect(record["contentLanguage"]).to eq(product.content_language)
    end

    it "has a channel" do
      expect(record["channel"]).to eq(product.channel)
    end

    it "has a condition" do
      expect(record["condition"]).to eq(product.condition)
    end

    it "has a product type" do
      expect(record["productType"]).to eq(product.product_type)
    end

    it "has a product category" do
      expect(record["productCategory"]).to eq(product.product_category)
    end

    it "has custom label 0" do
      expect(record["customLabel0"]).to eq(product.custom_label_0)
    end

    it "has custom label 1" do
      expect(record["customLabel1"]).to eq(product.custom_label_1)
    end

    it "has custom label 2" do
      expect(record["customLabel2"]).to eq(product.custom_label_2)
    end

    it "has custom label 3" do
      expect(record["customLabel3"]).to eq(product.custom_label_3)
    end

    it "has custom label 4" do
      expect(record["customLabel4"]).to eq(product.custom_label_4)
    end
  end

  describe "#bing_product_id" do
    subject(:product_id) { product.bing_product_id }

    let(:product) do
      build(:product,
            channel: "online",
            content_language: "en",
            target_country: "US",
            offer_id: "3051759-US-sticker")
    end

    it "builds a sane Bing id" do
      expect(product_id).to eq("online:en:US:3051759-US-sticker")
    end
  end
end
