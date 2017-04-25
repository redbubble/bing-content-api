require 'oauth2'

module Bing
  module Content
    module Api
      class Client
        attr_accessor :refresh_token_callback
        attr_reader :refresh_token
        attr_reader :developer_token

        #TODO this is temporary!!
        attr_reader :token
        ####

        REDIRECT_URI = "https://login.live.com/oauth20_desktop.srf".freeze
        BMC_HOST = "https://su1.content.api.bingads.microsoft.com".freeze


        def initialize(client_id, developer_token, merchant_id, refresh_token=nil)
          @client_id = client_id
          @developer_token = developer_token
          @merchant_id = merchant_id
          @refresh_token = refresh_token
          @token = nil
          @refresh_token_callback = nil

          @oauth_client = OAuth2::Client.new(@client_id,
            nil, # client secret isn't applicable for our use
            :site => 'https://login.live.com',
            :authorize_url => '/oauth20_authorize.srf',
            :token_url     => '/oauth20_token.srf',
            :redirect_uri  => REDIRECT_URI
          )
        end

        def runBatch(batch)
          batch_processor = Bing::Content::Api::BatchProcessor.new(self)
          batch_processor.execute batch
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

        def generate_user_authorisation_url
          @oauth_client.auth_code.authorize_url(
            :state => "ArizonaIsAState",
            :scope => "bingads.manage")
        end

        def fetch_token_with_code!(verified_url)
          @token = @oauth_client.auth_code.get_token(
            extract_code(verified_url),
            :redirect_uri => REDIRECT_URI
          )
          self.refresh_token = @token.refresh_token
        end

        def refresh_token!
          @token = OAuth2::AccessToken.new(@oauth_client, "")
          @token.refresh_token = @refresh_token
          @token = token.refresh!
          self.refresh_token = @token.refresh_token
        end

        def extract_code(redirected_url)
          /code=([0-9a-zA-Z\-]+)&/.match(redirected_url)[1]
        end

        def connection
          # TODO switch to HTTPI?
          @conn ||= Faraday.new(:url => BMC_HOST) do |faraday|
            faraday.request  :url_encoded
            faraday.response :detailed_logger # <-- Inserts the logger into the connection.
            faraday.adapter  Faraday.default_adapter
          end
          @conn
        end

        def base_uri
          "/shopping/v9.1/bmc/#{@merchant_id}"
        end
      end
    end
  end
end
