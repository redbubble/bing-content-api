FactoryGirl.define do
  factory :product, class: Bing::Content::Api::Product do
    transient do
      offer_id "3051759-US-sticker"
      title "Awesome sticker"
      description "this is the best sticker in the world"
      price 6.66
      currency "USD"
      product_link "https://www.redbubble-staging.com/people/toothbrush/works/3051759-a-thing-a-church?p=sticker&size=small"
      image_link "https://ih1.redbubble-staging.net/image.7202580.1759/sticker,375x360-bg,ffffff.jpg"
      target_country "US"
      content_language "en"
      availability "in stock"
    end
  end

  initialize_with do
    new(offer_id, title, description, price, currency, product_link, image_link, target_country, content_language, availability)
  end
end
