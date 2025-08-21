require "minitest/autorun"
require "webmock/minitest"
require "strike"

class Strike::Test < Minitest::Test
  def setup
    @client = Strike::Client.new(api_key: "test_api_key")
    WebMock.disable_net_connect!(allow_localhost: true)
  end
end