RSpec.describe Bing::Content::Api::BatchProcessor do
  context "has products" do
    let(:product1) { build(:product) }

    let(:connector) { double("Connector") }
    subject(:batchproc) { Bing::Content::Api::BatchProcessor.new(connector) }

    let(:batch) { Bing::Content::Api::Batch.new }

    it "starts empty" do
      batch.add_insertions([product1])
      expect(JSON.parse(batchproc.send(:to_body, batch))).to eq({
        "entries" => [{
                       "batchId"=>1000,
                       "product"=> {
                         "offerId"=>"3051759-US-sticker",
                         "title"=>"Awesome sticker",
                         "description"=>"this is the best sticker in the world",
                         "price"=>{"currency"=>"USD",
                                   "value"=>6.66},
                         "imageLink"=>"https://ih1.redbubble-staging.net/image.7202580.1759/sticker,375x360-bg,ffffff.jpg",
                         "link"=>"https://www.redbubble-staging.com/people/toothbrush/works/3051759-a-thing-a-church?p=sticker&size=small",
                         "targetCountry"=>"US",
                         "contentLanguage"=>"en",
                         "availability"=>"in stock",
                         "channel"=>"online",
                         "condition"=>"new"},
                       "method"=>"insert"
                      }]})
    end
  end
end
