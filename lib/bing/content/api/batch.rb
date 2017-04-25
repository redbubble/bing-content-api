module Bing
  module Content
    module Api
      class Batch

        attr_reader :to_update
        attr_reader :to_delete

        @counter = 0

        def initialize
          @to_update = []
          @to_delete = []
        end

        # TODO keep track of 1000 max operations in a batch?
        def add_insertions(products)
          # []#concat is in-place!  Ouch!
          @to_update.concat(products)
        end

        def add_deletions(products)
          @to_delete.concat(products)
        end

      end
    end
  end
end
