require 'sinatra/base'
require 'rack/cors'
require 'dotenv'
Dotenv.load
require 'fastenv'
require 'twilio-ruby'
require 'json'

class RandomNumberTexter < Sinatra::Base
  use Rack::Cors do
    allow do
      origins '*'
      resource '*', headers: :any, methods: [:get, :post, :options]
    end
  end

  # Idea from http://www.recursion.org/2011/7/21/modular-sinatra-foreman
  configure do
    set :app_file, __FILE__
    set :port, ENV['PORT'] || 9000
  end

  get '/' do
    status 200
    return <<-PAGE
    <html><head><title>Random Number Texter</title></head><body><h1>Random Number Texter</h1><p>Up and Running!</p></body></html>
    PAGE
  end

  post '/' do
    if request.content_type == 'application/json'
      request.body.rewind
      post_body = request.body.read

      payload = JSON.parse post_body

      is_random_number_generate = payload['event'] == 'random_number:generate'
      return unless is_random_number_generate

      has_payload_data = payload['data']
      return unless has_payload_data

      random_number = payload['data']

      send_text(random_number)
      status 201
      return post_body

    else
      status 202
      return post_body
    end
  end

private
  def send_text(random_number)
    begin
      @twilio_client ||=
        Twilio::REST::Client.new(twilio_sid, twilio_token)

      @twilio_client.account.messages.create(
        from: twilio_from_number,
        to:   twilio_to_number,
        body: "Here's a random number: #{random_number}"
      )

    rescue StandardError => e
      $stderr.puts <<-LOG
Error: Couldn't send SMS to #{twilio_to_number}..."
Details: #{e.inspect}
Backtrace:
#{e.backtrace.join("\n")}
      LOG
    end
  end

  def twilio_sid
    Fastenv.sms_twilio_sid
  end

  def twilio_token
    Fastenv.sms_twilio_token
  end

  def twilio_from_number
    Fastenv.sms_twilio_from_number
  end

  def twilio_to_number
    Fastenv.sms_twilio_to_number
  end

  run! if app_file == $0
end
