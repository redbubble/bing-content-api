module Bing
  module Content
    module Api
      class BatchProcessor
        def initialize(connector)
          @connector = connector
        end

        def execute(batch)
          post_body = batch.to_body
          http_response = @connector.post('/products/batch', post_body)
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

      end
    end
  end
end
