require 'oauth2'

module Bing
  module Content
    module Api
      class Client
        attr_accessor :refresh_token_callback
        attr_reader :refresh_token

        REDIRECT_URI = "https://login.live.com/oauth20_desktop.srf".freeze
        BMC_HOST = "https://su1.content.api.bingads.microsoft.com".freeze
        # BASE_URI = "/shopping/v9.1/bmc/#{MERCHANT_ID_STAGING}".freeze

        def initialize(client_id, developer_token, merchant_id, refresh_token=nil)
          @client_id = client_id
          @developer_token = developer_token
          @merchant_id = merchant_id
          @refresh_token = refresh_token
          @token = nil

          @refresh_token_callback = lambda do |x|
            puts "WARNING: this is the default refresh_token_callback."
            puts "You probably want to implement a callback to save your"\
              " refresh token!  Here it is, though:"
            puts x
          end

          @oauth_client = OAuth2::Client.new(@client_id,
            nil, # client secret isn't applicable for our use
            :site => 'https://login.live.com',
            :authorize_url => '/oauth20_authorize.srf',
            :token_url     => '/oauth20_token.srf',
            :redirect_uri  => REDIRECT_URI
          )
        end

        # def authorise!
        #   if not @refresh_token
        #     first_time_authorise!
        #   else
        #     begin
        #       refresh_token!
        #     rescue OAuth2::Error
        #       first_time_authorise!
        #     end
        #   end

        def runBatch(batch)
          # ..
        end

        def refresh_token=(value)
          @refresh_token_callback.call(value)
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
      end
    end
  end
end
