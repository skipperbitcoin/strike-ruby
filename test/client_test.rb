# test/client_test.rb
require_relative "test_helper"

class ClientTest < Strike::Test
  def setup
    super
    @client = Strike::Client.new(api_key: "test_api_key")
  end

  def test_create_invoice
    stub_request(:post, "https://api.strike.me/invoices").
    with(
      body: "{\"amount\":{\"currency\":\"USD\",\"amount\":\"10.5\"},\"description\":\"Test invoice\",\"correlationId\":\"asnosankn\"}",
      headers: {
      'Accept'=>'application/json',
      'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
      'Authorization'=>'Bearer test_api_key',
      'Content-Type'=>'application/json',
      'User-Agent'=>'Faraday v2.13.4'
      }).to_return(
        status: 201, 
        body: { id: "inv_123", status: "PENDING" }.to_json,
        headers: { "Content-Type" => "application/json" }
      )

    result = @client.create_invoice(10.50, currency: "USD", description: "Test invoice", external_id: "asnosankn")
    assert_equal("inv_123", result["id"])
    assert_equal("PENDING", result["status"])
  end

  def test_list_receives
    stub_request(:get, "https://api.strike.me/receive-requests/receives").
    with(
      headers: {
        'Accept'=>'application/json',
        'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
        'Authorization'=>'Bearer test_api_key',
        'Content-Type'=>'application/json',
        'User-Agent'=>'Faraday v2.13.4'
      }).to_return(
        status: 200,
        body: { receives: [{ id: "rec_123", amount: { currency: "USD", amount: "10.00" } }] }.to_json
      )

    result = @client.list_receives
    assert_equal(8, result["receives"].length)
    pp result
  end
end