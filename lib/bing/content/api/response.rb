module Bing
  module Content
    module Api
      class Response
        attr_reader :failures, :successes

        def initialize(response_entries, batch)
          @failures = batch.all_products
          @successes = []

          response_entries.each do |entry|
            id = entry["batchId"].to_i
            add_success(batch.product_by_batch_id(id))
          end
        end

        def add_success(product)
          @failures.delete_if { |prod| prod.offer_id == product.offer_id }
          @successes << product
        end
      end
    end
  end
end
