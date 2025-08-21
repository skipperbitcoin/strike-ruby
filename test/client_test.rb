require_relative "test_helper"

class ClientTest < Strike::Test
  def test_list_receives
    stub_request(:get, "https://api.strike.me/v1/receives")
      .with(headers: { "Authorization" => "Bearer dGVzdF9hcGlfa2V5Og==" })
      .to_return(status: 200, body: { receives: [] }.to_json)

    result = @client.list_receives
    assert_equal({ "receives" => [] }, result)
  end

  def test_create_invoice
    stub_request(:post, "https://api.strike.me/v1/invoices")
      .with(
        headers: { "Authorization" => "Bearer dGVzdF9hcGlfa2V5Og==" },
        body: {
          "amount" => { "currency" => "USD", "amount" => "10.50" },
          "description" => "Test invoice"
        }.to_json
      )
      .to_return(status: 201, body: { id: "inv_123", status: "PENDING" }.to_json)

    result = @client.create_invoice(10.50, currency: "USD", description: "Test invoice")
    assert_equal("inv_123", result["id"])
    assert_equal("PENDING", result["status"])
  end
end