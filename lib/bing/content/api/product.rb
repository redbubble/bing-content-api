module Bing
  module Content
    module Api
      class Product
        attr_accessor :offer_id, :title, :description, :price, :currency, :product_link, :image_link, :target_country, :content_language, :availability, :channel, :product_type, :product_category, :condition, :custom_label_0, :custom_label_1, :custom_label_2, :custom_label_3, :custom_label_4

        def bing_product_id
          "#{@channel}:#{@content_language}:#{@target_country}:#{@offer_id}"
        end

        def to_record
          {
            "offerId" => @offer_id,
            "title" => @title,
            "description" => @description,
            "price" => { "currency" => @currency, "value" => @price },
            "imageLink" => @image_link,
            "link" => @product_link,
            "targetCountry" => @target_country,
            "contentLanguage" => @content_language,
            "availability" => @availability,
            "channel" => @channel,
            "condition" => @condition,
            "productType" => @product_type,
            "googleProductCategory" => @product_category,
            "customLabel0" => @custom_label_0,
            "customLabel1" => @custom_label_1,
            "customLabel2" => @custom_label_2,
            "customLabel3" => @custom_label_3,
            "customLabel4" => @custom_label_4,
          }
        end
      end
    end
  end
end
