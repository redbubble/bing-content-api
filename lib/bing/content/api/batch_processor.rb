module Bing
  module Content
    module Api
      class BatchProcessor
        def initialize(oauth_client)
          @oauth_client = oauth_client
        end

        def execute(batch)
          post_body = to_body(batch)
          http_response = do_post(post_body)
          body = JSON.parse(http_response.body)
          entries = body["entries"]
          pp entries

          response = Bing::Content::Api::Response.new

        end

        def do_post(body)
          @oauth_client.connection.post do |req|
            req.url @oauth_client.base_uri + '/products/batch'
            # req.params['bmc-catalog-id'] = '148630' # this should be the default cat
            req.headers['Content-Type'] = 'application/json'
            req.headers['DeveloperToken'] = @oauth_client.developer_token
            req.headers['AuthenticationToken'] = @oauth_client.token.token
            req.body = body
          end
        end

        def to_body(batch)
          operations = batch.operations.map do |op|
            op.bing_operation
          end

          { entries: operations }.to_json
        end

        # def insert_operations(batch)
        #   batch.to_update.map do |product|
        #     { method: "insert",
        #       product: product.to_record }
        #   end
        # end

        # def delete_operations(batch)
        #   batch.to_delete.map do |product|
        #     { method: "delete",
        #       productId: product.bing_product_id }
        #   end
        # end
      end
    end
  end
end
