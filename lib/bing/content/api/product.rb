module Bing
  module Content
    module Api
      class Product
        def initialize(offer_id,
                       title,
                       description,
                       price,
                       product_link,
                       image_link,
                       target_country="US",
                       content_language="en",
                       availability="in stock")
          @offer_id = offer_id
          @title = title
          @description = description
          @price = price
          @product_link = product_link
          @image_link = image_link
          @target_country = target_country
          @content_language = content_language
          @availability = availability
        end

        def bing_product_id
          "#{@channel}:#{@content_language}:#{@target_country}:#{@offer_id}"
        end

        def to_record
          {
            offerId: @offer_id,
            title: @title,
            description: @description,
            price: { currency: "USD", value: @price },
            imageLink: @image_link,
            link: @product_link,
            targetCountry: @target_country,
            contentLanguage: @content_language,
            availability: @availability,
            channel: "online",
            condition: "new",
          }
        end
      end
    end
  end
end
