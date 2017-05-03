module Bing
  module Content
    module Api
      class Response
        attr_reader :failures, :successes

        def initialize(response_entries, batch)
          @failures = []
          @successes = []

          response_entries.each do |entry|
            id = entry["batchId"].to_i
            error = entry["errors"]
            if error
              failures << { response: entry, product: batch.product_by_batch_id(id) }
            else
              successes << { response: entry, product: batch.product_by_batch_id(id) }
            end
          end
        end
      end
    end
  end
end
