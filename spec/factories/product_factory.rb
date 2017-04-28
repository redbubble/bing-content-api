FactoryGirl.define do
  factory :product, class: Bing::Content::Api::Product do
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
    channel "online"
    condition "new"
  end
end
