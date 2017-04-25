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

          response = Bing::Content::Api::Response.new
          response.set_all_products(batch.all_products)

          entries.each do |entry|
            id = entry["batchId"].to_i
            response.add_success(batch.product_by_batch_id(id))
          end

          response
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
      end
    end
  end
end
