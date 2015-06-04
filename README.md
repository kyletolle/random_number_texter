# Random Number Texter

Accept a POST request with a generated random number and send it in an SMS.

## Install

`bundle install --path=.bundle`

## Setup

You'll need to set some environment variables with your twilio credentials.
You can use a Twilio trial account for this too!

- `SMS_TWILIO_SID`
- `SMS_TWILIO_TOKEN`
- `SMS_TWILIO_FROM_NUMBER`
  - This is your trial phone number that Twilio gave you.
- `SMS_TWILIO_TO_NUMBER`
  - This is your phone number that you verified with Twilio.

## Running

`bundle exec foreman start`

Note: You can change the port with an environment variable `PORT`.

## Making a POST request

```
curl -X POST -H 'Content-Type: application/json' -d '{"id":"first","event":"random_number:generate","data":2048}' http://localhost:9000
```

This will text the random number in the payload's `data` to the number from
the environment variable.

## License

MIT

