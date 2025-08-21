# Strike Ruby Client

[![Gem Version](https://badge.fury.io/rb/strike.svg)](https://badge.fury.io/rb/strike)


A Ruby client for the [Strike API](https://docs.strike.me/api/) that makes it easy to integrate Bitcoin Lightning payments into your Ruby applications.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'strike'
```
And then execute:
```
bundle install
```

Create api key in [Strike Dashboard](https://dashboard.strike.me/api-keys)

Add Strike Api Key to rails secrets:
```
strike:
  api_key: "your_api_key_here"
```

## Usage

```
# Create invoice for $10.50 USD
invoice = Strike.client.create_invoice(
  10.50,
  currency: "USD",
  description: "Premium subscription",
  due_date: Time.now + 86400 # 24 hours from now
)

# List all payments
payments = Strike.client.list_receives(limit: 50)

# Check specific payment
payment = Strike.client.receive_payment("pay_123456789")
```