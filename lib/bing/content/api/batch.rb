module Bing
  module Content
    module Api
      class Batch
        attr_reader :operations

        def initialize
          @operations = []

          @ids = (1..1000).to_a
        end

        def add_insertions(products)
          products.each do |prod|
            @operations << BatchOperation.new(@ids.pop, prod, :insert)
          end
        end

        def add_deletions(products)
          products.each do |prod|
            @operations << BatchOperation.new(@ids.pop, prod, :delete)
          end
        end

        def all_products
          @operations.map(&:product)
        end

        def product_by_batch_id(id)
          @operations.select { |op| op.batch_id == id }.first.product
        end

        def to_body
          json_operations = @operations.map(&:bing_operation)
          { entries: json_operations }.to_json
        end
      end
    end
  end
end
