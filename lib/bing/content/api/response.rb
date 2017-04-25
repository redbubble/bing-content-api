module Bing
  module Content
    module Api
      class Response
        def initialize
          @successes = []
          @failures = []
        end

        def add_success(product)
          @failures.delete_if { |prod| prod.offer_id == product.offer_id }
          @successes << product
        end

        def set_all_products(products)
          @failures = products
        end
      end
    end
  end
end
