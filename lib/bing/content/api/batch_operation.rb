module Bing
  module Content
    module Api
      class BatchOperation

        def initialize(batch_id, product, action=:insert)
          raise "asdf" unless [:insert, :delete].include? action

          @batch_id = batch_id
          @product = product
          @action = action
        end

        def bing_operation
          operation = { batchId: @batch_id }
          case @action
          when :insert
            operation[:product] = @product.to_record
            operation[:method] = "insert"
          when :delete
            operation[:productId] = @product.bing_product_id
            operation[:method] = "delete"
          end
          operation
        end
      end
    end
  end
end
