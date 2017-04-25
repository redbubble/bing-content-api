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
        bing_client.refresh_token!
        expect(bing_client.refresh_token).to eq("refreshtokenAAAfoo")
      end
    end

    it "makes callback with new refresh token" do
      VCR.use_cassette("oauth-refresh") do
        callback = lambda { |token| }
        expect(callback).to receive(:call).with("refreshtokenAAAfoo")
        bing_client.refresh_token_callback = callback
        bing_client.refresh_token!
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

    it "raises an exception" do
      VCR.use_cassette("oauth-invalid-refresh") do
        expect { bing_client.refresh_token! }.to raise_error(OAuth2::Error, /invalid_grant/)
      end
    end
  end

  context "consumer hasn't set refresh_token" do
    subject(:bing_client) {
      Bing::Content::Api::Client.new(
        "app_id_foo",
        "developer_id_foo",
        "merchant_id_foo") }

    it "returns URL to visit for authorisation" do
      expect(bing_client.generate_user_authorisation_url).to eq("https://login.live.com/oauth20_authorize.srf?client_id=app_id_foo&redirect_uri=https%3A%2F%2Flogin.live.com%2Foauth20_desktop.srf&response_type=code&scope=bingads.manage&state=ArizonaIsAState")
    end

    it "converts code into refresh_token" do
      VCR.use_cassette("code-to-token") do
        callback = lambda { |token| }
        expect(callback).to receive(:call).with("refresh_token_totoAAA")
        bing_client.refresh_token_callback = callback
        bing_client.fetch_token_with_code!("https://login.live.com/oauth20_desktop.srf?code=code-toto&state=ArizonaIsAState&lc=1033")
      end
    end
  end
end
