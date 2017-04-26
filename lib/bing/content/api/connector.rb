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
          connection.get do |req|
            req.url base_uri + path
            req.headers['Content-Type'] = 'application/json'
            add_auth_headers(req)
          end
        end

        def post(path, body)
          connection.post do |req|
            req.url base_uri + path
            # req.params['bmc-catalog-id'] = '148630' # this should be the default cat
            req.headers['Content-Type'] = 'application/json'
            add_auth_headers(req)
            req.body = body
          end
        end

        private

        def connection
          # TODO switch to HTTPI?
          @connection ||= Faraday.new(:url => BMC_HOST) do |faraday|
            faraday.request  :url_encoded
            faraday.response :detailed_logger # <-- Inserts the logger into the connection.
            faraday.adapter  Faraday.default_adapter
          end
        end

        def add_auth_headers(req)
          req.headers['DeveloperToken'] = @developer_token
          req.headers['AuthenticationToken'] = @token.token
        end

        def base_uri
          "/shopping/v9.1/bmc/#{@merchant_id}"
        end
      end
    end
  end
end
