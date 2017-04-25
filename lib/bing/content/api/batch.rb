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

      end
    end
  end
end
