require 'httpi'

module Bing
  module Content
    module Api
      class Connector
        BMC_HOST = "https://su1.content.api.bingads.microsoft.com".freeze

        def initialize(developer_token, token, merchant_id)
          @developer_token = developer_token
          @token = token
          @merchant_id = merchant_id
        end

        def get(path)
          request = HTTPI::Request.new
          request.url = BMC_HOST + base_uri + path
          # req.params['bmc-catalog-id'] = '148630' # this should be the default cat
          request.headers['Content-Type'] = 'application/json'
          add_auth_headers(request)
          HTTPI.get(request)
        end

        def post(path, body)
          request = HTTPI::Request.new
          request.url = BMC_HOST + base_uri + path
          request.body = body
          request.headers['Content-Type'] = 'application/json'
          add_auth_headers(request)
          HTTPI.post(request)
        end

        private

        def add_auth_headers(req)
          req.headers['DeveloperToken'] = @developer_token
          req.headers['AuthenticationToken'] = @token
        end

        def base_uri
          "/shopping/v9.1/bmc/#{@merchant_id}"
        end
      end
    end
  end
end
