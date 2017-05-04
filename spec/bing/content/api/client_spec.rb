RSpec.describe Bing::Content::Api::Client do

  let(:refresh_token) { "foobarbaz" }
  let(:bing_client) do
    described_class.new("app_id_foo",
                        "dev_token_foo",
                        "merchant_id_foo",
                        refresh_token)
  end

  describe "#retrieve_catalogue" do
    context "has valid refresh_token" do
      let(:response) { instance_double("HTTPI::Response", body: "{}") }

      before do
        allow_any_instance_of(Bing::Content::Api::Connector).to receive(:get).and_return(response)
      end

      it "successfully refreshes an OAuth token" do
        VCR.use_cassette("oauth-refresh") do
          bing_client.retrieve_catalogue
          expect(bing_client.refresh_token).to eq("refreshtokenAAAfoo")
        end
      end

      it "makes callback with new refresh token" do
        VCR.use_cassette("oauth-refresh") do
          callback = ->(token) {}
          expect(callback).to receive(:call).with("refreshtokenAAAfoo")
          bing_client.refresh_token_callback = callback
          bing_client.retrieve_catalogue
        end
      end
    end
  end

  context "has invalid refresh_token" do

    let(:refresh_token) { "foobarbazINVALID" }

    it "raises an exception" do
      VCR.use_cassette("oauth-invalid-refresh") do
        expect { bing_client.send(:refresh_token!) }.to raise_error(OAuth2::Error, /invalid_grant/)
      end
    end
  end

  describe "#generate_user_authorisation_url" do
    context "consumer hasn't set refresh_token" do
      it "returns URL to visit for authorisation" do
        expect(bing_client.generate_user_authorisation_url).to eq("https://login.live.com/oauth20_authorize.srf?client_id=app_id_foo&redirect_uri=https%3A%2F%2Flogin.live.com%2Foauth20_desktop.srf&response_type=code&scope=bingads.manage&state=ArizonaIsAState")
      end
    end
  end

  describe "#fetch_token_with_code!" do
    it "converts code from URL into refresh_token" do
      VCR.use_cassette("code-to-token") do
        callback = ->(token) {}
        expect(callback).to receive(:call).with("refresh_token_totoAAA")
        bing_client.refresh_token_callback = callback
        bing_client.fetch_token_with_code!("https://login.live.com/oauth20_desktop.srf?code=code-toto&state=ArizonaIsAState&lc=1033")
      end
    end
  end
end
