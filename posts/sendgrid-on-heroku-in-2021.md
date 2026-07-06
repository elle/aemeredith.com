---
title: SendGrid on Heroku in 2021
date: 2021-02-17
description: A quick write up on getting SendGrid to play nicely on Heroku
---
# SendGrid on Heroku in 2021

In the end of 2020 SendGrid required customers to enable two-factor authentication,
which means they stopped accepting SMTP requests made
with username and password via Basic Authentication.
This is better for security since
providing account username and password for authenticating against the SendGrid SMTP API
gives full access to your SendGrid account,
and therefore it is a security risk if these credentials get compromised.
Using API Keys adds an additional layer of security,
and is the recommended way to securely talk to SendGrid APIs.

This means that by default the behaviour of the Twilio SendGrid addon
may be somewhat unexpected.
It still automatically adds a `SENDGRID_USERNAME` and `SENDGRID_PASSWORD`
to your app's environment variables,
but sending emails straight out of the box will no longer work.

There's a simple workaround. You will need to log into your Twilio SendGrid account and:

1. Generate an API key under "Settings" > "API Keys".
   Give it a name, and select "Restricted Access".
   Restricted Access is recommended as it customises levels of access for all parts of your account.
1. To send email only, your API key will require **"Mail Send" > "Full Access permissions"**.
1. To use your API key with the SMTP integration, set your username to be "apikey".
   Your password will be the API key you generated in the previous step.

In my Environment variables I use the following values:

```yaml
SMTP_USERNAME: "apikey"
SMTP_PASSWORD: <Generated API Key starts with SG.>
SMTP_AUTHENTICATION: "plain"
SMTP_ADDRESS: smtp.sendgrid.net
SMTP_PORT: 587
```

Then in my Rails app, I have the following setup:

```rb
# config/smtp.rb
SMTP_SETTINGS = {
  address: ENV.fetch("SMTP_ADDRESS"),
  authentication: ENV.fetch("SMTP_AUTHENTICATION", "plain"),
  domain: ENV.fetch("SMTP_DOMAIN"),
  enable_starttls_auto: true,
  password: ENV.fetch("SMTP_PASSWORD"),
  port: ENV.fetch("SMTP_PORT", "587"),
  user_name: ENV.fetch("SMTP_USERNAME"),
}.freeze

# config/environments/production.rb
require Rails.root.join("config/smtp")

Rails.application.configure do
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = SMTP_SETTINGS
end

# app.json
{
  # ..
  "env": {
    "SMTP_ADDRESS": {
      "required": true
    },
    "SMTP_DOMAIN": {
      "required": true
    },
    "SMTP_PASSWORD": {
      "required": true
    },
    "SMTP_USERNAME": {
      "required": true
    }
  },
}
```

Working all this out required a number of conversations with both Twilio and Heroku support.
Considering that this change is required for new and old SendGrid clients,
I would expected Heroku support to be on top of this,
and that the documentation would be more upfront.
In any case, here are a few more references:

- [Heroku Dev Center on Twillio SendGrid](https://devcenter.heroku.com/articles/sendgrid)
- [Upgrade your authentication method to API keys](https://sendgrid.com/docs/for-developers/sending-email/upgrade-your-authentication-method-to-api-keys/)
- [Integrating with the SMTP API](https://sendgrid.com/docs/for-developers/sending-email/integrating-with-the-smtp-api/)
- [SendGrid documentation on API keys](https://sendgrid.com/docs/ui/account-and-settings/api-keys/)
