RSpec.describe Bing::Content::Api::BatchProcessor do

  describe "#execute" do
    subject(:batchproc) { described_class.new(connector).execute(batch) }

    let(:product1) { build(:product) }
    let(:connector) { instance_double("Connector") }
    let(:response) { instance_double("Response", body: '{"entries": []}', error?: false) }
    let(:batch) { Bing::Content::Api::Batch.new }

    it "posts a payload to the batch endpoint" do
      expect(connector).to receive(:post).with('/products/batch', anything).and_return(response)
      batchproc
    end
  end
end
