require 'oauth2'

module Bing
  module Content
    module Api
      class Client
        attr_accessor :refresh_token_callback
        attr_reader :refresh_token
        attr_reader :developer_token

        REDIRECT_URI = "https://login.live.com/oauth20_desktop.srf".freeze

        def initialize(client_id, developer_token, merchant_id, refresh_token=nil, catalogue_id=nil)
          @client_id = client_id
          @developer_token = developer_token
          @merchant_id = merchant_id
          @refresh_token = refresh_token
          @catalogue_id = catalogue_id
          @token = nil
          @refresh_token_callback = nil
        end

        def generate_user_authorisation_url
          oauth_client.auth_code.authorize_url(
            :state => "ArizonaIsAState",
            :scope => "bingads.manage")
        end

        def fetch_token_with_code!(verified_url)
          @token = oauth_client.auth_code.get_token(
            extract_code(verified_url),
            :redirect_uri => REDIRECT_URI
          )
          self.refresh_token = @token.refresh_token
        end

        def run_batch(batch)
          batch_processor = Bing::Content::Api::BatchProcessor.new(connector)
          batch_processor.execute(batch)
        end

        def retrieve_catalogue
          response = connector.get('/products')
          JSON.parse(response.body)["resources"]
        end

        private

        def refresh_token!
          @token = OAuth2::AccessToken.new(oauth_client, "")
          @token.refresh_token = @refresh_token
          @token = @token.refresh!
          self.refresh_token = @token.refresh_token
        end

        def refresh_token=(value)
          if @refresh_token_callback then
            @refresh_token_callback.call(value)
          else
            puts "WARNING: this is the default refresh_token_callback."
            puts "You probably want to implement a callback to save your"\
              " refresh token!  Here it is, though:"
            puts value
          end
          @refresh_token = value
        end

        def extract_code(redirected_url)
          /code=([0-9a-zA-Z\-]+)&/.match(redirected_url)[1]
        end

        def connector
          refresh_token! unless @connector
          @connector ||= Bing::Content::Api::Connector.new(@developer_token,
                                                           @token.token,
                                                           @merchant_id,
                                                           @catalogue_id)
        end

        def oauth_client
          @oauth_client ||= OAuth2::Client.new(@client_id,
            nil, # client secret isn't applicable for our use
            :site => 'https://login.live.com',
            :authorize_url => '/oauth20_authorize.srf',
            :token_url     => '/oauth20_token.srf',
            :redirect_uri  => REDIRECT_URI
          )
        end
      end
    end
  end
end
