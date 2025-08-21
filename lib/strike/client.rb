# lib/strike/client.rb
require "faraday"
require "json"

module Strike
  class Client
    API_BASE = "https://api.strike.me/v1".freeze
    DEFAULT_HEADERS = {
      "Content-Type" => "application/json",
      "Accept" => "application/json"
    }.freeze

    attr_accessor :api_key

    def initialize(api_key: nil)
      @api_key = api_key || ENV["STRIKE_API_KEY"]
      raise "STRIKE_API_KEY environment variable not set" unless @api_key
    end

    def list_receives(params = {})
      get("/receives", params)
    end

    def create_invoice(amount, currency:, description: nil, due_date: nil, external_id: nil)
      payload = {
        amount: { currency: currency, amount: amount.to_s },
        description: description,
        dueDate: due_date&.iso8601,
        externalId: external_id
      }.compact

      post("/invoices", payload)
    end

    def get_invoice(invoice_id)
      get("/invoices/#{invoice_id}")
    end

    def receive_payment(payment_id)
      get("/payments/#{payment_id}")
    end

    private

    def connection
      @connection ||= Faraday.new(url: API_BASE) do |conn|
        conn.headers = DEFAULT_HEADERS
        conn.basic_auth(@api_key, "")
        conn.request :json
        conn.response :json, content_type: /\bjson$/
        conn.adapter Faraday.default_adapter
      end
    end

    def get(path, params = {})
      response = connection.get(path, params)
      handle_response(response)
    end

    def post(path, payload)
      response = connection.post(path) do |req|
        req.body = payload.to_json
      end
      handle_response(response)
    end

    def handle_response(response)
      case response.status
      when 200..299
        response.body
      when 400
        raise BadRequest, parse_error(response)
      when 401
        raise Unauthorized, "Invalid API key"
      when 403
        raise Forbidden, "Insufficient permissions"
      when 404
        raise NotFound, "Resource not found"
      when 429
        raise RateLimited, "API rate limit exceeded"
      else
        raise Error, "Unexpected error (#{response.status}): #{response.body}"
      end
    end

    def parse_error(response)
      body = response.body
      if body.is_a?(Hash) && (errors = body["errors"])
        errors.map { |e| "#{e['code']}: #{e['message']}" }.join(", ")
      else
        response.body.to_s
      end
    end

    class Error < StandardError; end
    class BadRequest < Error; end
    class Unauthorized < Error; end
    class Forbidden < Error; end
    class NotFound < Error; end
    class RateLimited < Error; end
  end
end