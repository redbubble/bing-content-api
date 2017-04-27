# Bing::Content::Api

This Gem is intended to be an as-thin-as-possible wrapper around the
Bing Ads Content API.

## Prerequisites

You'll need a Bing Merchant Center account, as well as an application
that you've created using your Microsoft Developer account.  This will
give you your "application id", "developer token", and "merchant id"
which we'll use in the rest of the code.

This library also expects you to manage your refresh tokens, so you'll
be wanting to save them to a local file, S3, or whatever makes sense
in your ecosystem.

## Installation

The usual.  Add this line to your application's Gemfile:

```ruby
gem 'bing-content-api'
```

And then execute:

    $ bundle

## Usage

You'll need to get yourself an authentication token, first.
Unfortunately, that's a process that requires interactive user
intervention.  Once you've got a refresh token though, you shouldn't
need to worry about manual intervention any more.

```ruby
auth = retrieve_my_saved_token
bing_client = Bing::Content::Api::Client.new(APPLICATION_ID,
                                             DEVELOPER_TOKEN,
                                             MERCHANT_ID_STAGING,
                                             refresh_token=auth)
```

Instantiating the `Client` class will automatically fetch a refresh
token for you.  If you still need to get a token, you'll probably want
to do something like the following:

```ruby
puts bing_client.generate_user_authorisation_url
code = gets.strip
bing_client.fetch_token_with_code!(code)
```

Right, we're in business!  When you've got the required tokens, you'll
probably want to do something like the following.  First, create some
products:

```ruby
def product(n=0)
  Bing::Content::Api::Product.new(
    "sticker-#{n}",
    "Awesome sticker ##{n}",
    "this is the best sticker in the world ##{n}",
    6.66,
    "https://www.your-store.com/people/toothbrush/works/3051759-a-thing?p=sticker&size=small",
    "https://ih1.your-store.net/image.72080/sticker,375x360.jpg",
    "US",
    "en",
    "in stock")
end
```

Now, submit it to the store:

```ruby
batch = Bing::Content::Api::Batch.new()
batch.add_insertions([product(1)])
response1 = bing_client.runBatch(batch)
```

Let's see what's in the catalogue:

```ruby
response2 = bing_client.retrieve_catalogue
```

Your catalogue should now contain a product!

## Development

After checking out the repo, run `bin/setup` to install
dependencies. Then, run `bundle exec rspec` to run the tests. You can
also run `bin/console` for an interactive prompt that will allow you
to experiment.

To install this gem onto your local machine, run `bundle exec rake
install`. To release a new version, update the version number in
`version.rb`, and then run `bundle exec rake release`, which will
create a git tag for the version, push git commits and tags, and push
the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/redbubble/bing-content-api. This project is
intended to be a safe, welcoming space for collaboration, and
contributors are expected to adhere to
the [Contributor Covenant](http://contributor-covenant.org) code of
conduct.


## License

The gem is available as open source under the terms of
the [WTFPL License](http://www.wtfpl.net/).

