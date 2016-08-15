# letsencrypt_http_challenge
A Rails::Engine answering Let's Encrypt ACME - Simple HTTP - Identifier Validation Challenges on a twelve-factor app along with the rake task to automate the certificate generation.


## Installation

In you application, add this line to your Gemfile:
```ruby
gem 'letsencrypt_http_challenge'
```

Install the gem with bundler:
```bash
$ bundle install
```
Or manually with the gem command:
```bash
$ gem install letsencrypt_http_challenge
```

Mount the engine in your application's routes.rb file
```ruby
Rails.application.routes.draw do
  mount LetsencryptHttpChallenge::Engine => "/" unless ENV['LE_HTTP_CHALLENGE_RESPONSE'].blank?

  # Other routes...

end
```


## Usage

Run the interactive `generate_letsencrypt_cert` rake task from your local machine, setting the necessary environment variables:
```bash
$ LE_HTTP_CHALLENGE_CONTACT_EMAIL=admin@example.com LE_HTTP_CHALLENGE_CERTIFICATE_DOMAINS="www.example.com example.com" bundle exec rake generate_letsencrypt_cert
```

This will interact with the staging server. To obtain certificates from the production server, also add `LE_HTTP_CHALLENGE_ENDPOINT='https://acme-v01.api.letsencrypt.org/'` to your environment

When prompted by the script, update the LE_HTTP_CHALLENGE_RESPONSE variable on the web server and restart it. This could be further automated depending on the features of the web server hosting environment. The initial release require manual updates for each domain that needs to be verified.

Run the test suite with:
```bash
bundle exec rake
```

A sample interaction could be as follow:
```bash
LE_HTTP_CHALLENGE_CONTACT_EMAIL=admin@example.com LE_HTTP_CHALLENGE_CERTIFICATE_DOMAINS="www.example.com example.com" bundle exec rake generate_letsencrypt_cert
Registering with Let's Encrypt service...
Success
Sending authorization request(s)...

Set
LE_HTTP_CHALLENGE_RESPONSE=6DOqR_BmMD02pYh-Rwpo3-1Dy-EauqbN_bFMbCypnsI.Iv478AtdWnuUCE6e-UfAJFN6y-F3YUTYG-skUvfYPJc
on your Rails web server and restart it.

You can test by pointing your browser to
www.example.com/.well-known/acme-challenge/6DOqR_BmMD02pYh-Rwpo3-1Dy-EauqbN_bFMbCypnsI

Looking good?
Press any key to continue.
Requesting verification...

Set
LE_HTTP_CHALLENGE_RESPONSE=JvWeOoR-NgyQINyR92QhtFPOL7txd8EHSx94Lh466p4.Iv478AtdWnuUCE6e-UfAJFN6y-F3YUTYG-skUvfYPJc
on your Rails web server and restart it.

You can test by pointing your browser to
example.com/.well-known/acme-challenge/JvWeOoR-NgyQINyR92QhtFPOL7txd8EHSx94Lh466p4

Looking good?
Press any key to continue.
Requesting verification...

Requesting the certificate...
Certificate saved
```

For a server hosted on Heroku:
```bash
# Set the variable manually from the command line or from their web based console
heroku config:set LE_HTTP_CHALLENGE_RESPONSE=JPizvzEPdRV4c4jRuNeFiLt0CCzL4aX-m4Ota1WYxh4.E_dQtIfQA9oIW2T7stzq9SgogpUQS2Ha2A4mxlCeAPk --app your_app_name

# Deleted it after the verification is done
heroku config:unset LE_HTTP_CHALLENGE_RESPONSE --app your_app_name

# Update an existing certificate
heroku certs:update fullchain.pem privkey.pem --app your_app_name
```

For more information about SSL on Heroku, please refer to their Dev Center article:
https://devcenter.heroku.com/articles/ssl-endpoint

Finally, store the certificate files created by the script `privkey.pem cert.pem chain.pem fullchain.pem` in a safe location.


## TODO

- Automate the deployment on Heroku and other hosting services


## Acknowledgements

LetsencryptHttpChallenge was inspired by:

- lgromanowski/letsencrypt-plugin https://github.com/lgromanowski/letsencrypt-plugin
- unixcharles/acme-client https://github.com/unixcharles/acme-client


## License

[MIT License](http://opensource.org/licenses/MIT)
