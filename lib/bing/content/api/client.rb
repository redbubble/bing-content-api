require 'oauth2'

module Bing
  module Content
    module Api
      class Client
        attr_accessor :refresh_token_callback

        REDIRECT_URI = "https://login.live.com/oauth20_desktop.srf".freeze
        BMC_HOST = "https://su1.content.api.bingads.microsoft.com".freeze
        # BASE_URI = "/shopping/v9.1/bmc/#{MERCHANT_ID_STAGING}".freeze

        def initialize(client_id, developer_token, merchant_id, refresh_token=nil)
          # TODO check for reasonable client_id and developer_token?
          @client_id = client_id
          @developer_token = developer_token
          @merchant_id = merchant_id
          @refresh_token = refresh_token

          @refresh_token_callback = lambda do |x|
            puts "WARNING: this is the default refrest_token_callback."
            puts "You probably want to implement a callback to save your"\
              " refresh token!  Here it is, though:"
            puts x
          end

          @oauth_client = OAuth2::Client.new(@client_id,
            nil,
            :site => 'https://login.live.com',
            :authorize_url => '/oauth20_authorize.srf',
            :token_url     => '/oauth20_token.srf',
            :redirect_uri  => REDIRECT_URI
          )
        end

        def authorise!
          if not @refresh_token
            first_time_authorise!
          else
            begin
              refresh_token!
            rescue OAuth2::Error
              first_time_authorise!
            end
          end

        end

        alias_method :authorize!, :authorise!

        def runBatch(batch)
          # ..
        end

        private

        def first_time_authorise!
          url = @oauth_client.auth_code.authorize_url(
            :state => "ArizonaIsAState",
            :scope => "bingads.manage")

          puts "Visit this URL:"
          puts url
          puts "When you've authorized that token, enter the redirected URL:"
          redirected_url = gets.strip
          token = @oauth_client.auth_code.get_token(
            extract_code(redirected_url),
            :redirect_uri => REDIRECT_URI
          )

          @refresh_token_callback.call(token.refresh_token)
        end

        def refresh_token!
          token = OAuth2::AccessToken.new(@oauth_client, "")
          token.refresh_token = @refresh_token
          token = token.refresh!
          @refresh_token_callback.call(token.refresh_token)
        end

        def extract_code(redirected_url)
          /code=([0-9a-zA-Z\-]+)&/.match(redirected_url)[1]
        end
      end
    end
  end
end
