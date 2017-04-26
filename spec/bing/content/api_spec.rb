require "spec_helper"

RSpec.describe Bing::Content::Api do
  it "has a version number" do
    expect(Bing::Content::Api::VERSION).not_to be nil
  end
end
