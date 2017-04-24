VCR.configure do |config|
  config.cassette_library_dir = "fixtures/vcr_cassettes"
  config.hook_into :faraday
end

RSpec.describe Bing::Content::Api::Client do

  context "has valid refresh_token" do

    subject(:bing_client) {
      Bing::Content::Api::Client.new(
        "app_id_foo",
        "dev_token_foo",
        "merchant_id_foo",
        refresh_token="foobarbaz") }

    it "successfully refreshes an OAuth token" do
      VCR.use_cassette("oauth-refresh") do
        bing_client.authorise!
        expect(bing_client.refresh_token).to eq("refreshtokenAAAfoo")
      end
    end

    it "makes callback with new refresh token" do
      VCR.use_cassette("oauth-refresh") do
        callback = lambda { |token| }
        expect(callback).to receive(:call).with("refreshtokenAAAfoo")
        bing_client.refresh_token_callback = callback
        bing_client.authorise!
      end
    end
  end
  context "has invalid refresh_token" do

    subject(:bing_client) {
      Bing::Content::Api::Client.new(
        "app_id_foo",
        "dev_token_foo",
        "merchant_id_foo",
        refresh_token="foobarbazINVALID") }

    it "gets the user to intervene and provide OAuth code" do
      VCR.use_cassette("oauth-invalid-refresh") do
        expect(bing_client).to receive(:first_time_authorise!) # eq("refreshtokenBBBfoo")
        bing_client.authorise!
      end
    end

    # it "makes callback with new refresh token" do
    #   VCR.use_cassette("oauth-refresh") do
    #     callback = lambda { |token| }
    #     expect(callback).to receive(:call).with("refreshtokenAAAfoo")
    #     bing_client.refresh_token_callback = callback
    #     bing_client.authorise!
    #   end
    # end
  end
end
