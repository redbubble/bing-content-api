require 'httpi'

module Bing
  module Content
    module Api
      class Connector
        BMC_HOST = "https://su1.content.api.bingads.microsoft.com".freeze

        def initialize(developer_token, token, merchant_id, catalogue_id)
          @developer_token = developer_token
          @token = token
          @merchant_id = merchant_id
          @catalogue_id = catalogue_id
        end

        def get(path)
          request = HTTPI::Request.new
          request.url = BMC_HOST + base_uri + path
          request.headers['Content-Type'] = 'application/json'
          add_auth_headers(request)
          HTTPI.get(request)
        end

        def post(path, body)
          request = HTTPI::Request.new
          params = { :"bmc-catalog-id" => @catalogue_id } if @catalogue_id
          url = BMC_HOST + base_uri + path_with_params(path, params)
          request.url = url
          request.body = body
          request.headers['Content-Type'] = 'application/json'
          add_auth_headers(request)
          HTTPI.post(request)
        end

        private

        def path_with_params(path, params)
          return path unless params
          encoded_params = URI.encode_www_form(params)
          [path, encoded_params].join("?")
        end

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
