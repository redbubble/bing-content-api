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
          raise http_response.body if http_response.error?
          body = JSON.parse(http_response.body)
          entries = body["entries"]

          Bing::Content::Api::Response.new(entries, batch)
        end
      end
    end
  end
end
