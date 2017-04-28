RSpec.describe Bing::Content::Api::BatchProcessor do

  describe "#execute" do
    let(:product1) { build(:product) }
    let(:connector) { double("Connector") }
    let(:response) { double("Response", body: '{"entries": []}') }
    let(:batch) { Bing::Content::Api::Batch.new }
    subject(:batchproc) { Bing::Content::Api::BatchProcessor.new(connector).execute(batch) }

    it "posts a payload to the batch endpoint" do
      expect(connector).to receive(:post).with('/products/batch', anything).and_return(response)
      subject
    end
  end
end
