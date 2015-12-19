# Sample usage:
# LE_HTTP_CHALLENGE_CONTACT_EMAIL=admin@example.com LE_HTTP_CHALLENGE_CERTIFICATE_DOMAINS="www.example.com example.com" bundle exec rake generate_letsencrypt_cert
# Using the staging endpoint by default. Also set
# LE_HTTP_CHALLENGE_ENDPOINT='https://acme-v01.api.letsencrypt.org/'
# for production

# LE_HTTP_CHALLENGE_ENDPOINT - (Optional) The staging endpoint will be used unless defined.
# LE_HTTP_CHALLENGE_CONTACT_EMAIL - Domain contact email.
# LE_HTTP_CHALLENGE_CERTIFICATE_DOMAINS - The domains and sub-domains for which the certificate is requested.
# The first domain in the list will be the "Common Name" of the certificate.

# LE_HTTP_CHALLENGE_RESPONSE - The response to provide to the ACME challenge; Must be defined for the web server.


desc "Generate Let's Encrypt certificate with the http challenge"
task :generate_letsencrypt_cert do

  require 'io/console'
  require 'openssl'
  require 'acme-client'

  options = {
      endpoint: ENV.fetch('LE_HTTP_CHALLENGE_ENDPOINT', 'https://acme-staging.api.letsencrypt.org/'),
      contact_email: ENV.fetch('LE_HTTP_CHALLENGE_CONTACT_EMAIL'),
      domains: ENV.fetch('LE_HTTP_CHALLENGE_CERTIFICATE_DOMAINS').split
  }

  def generate_cert(options)
    client = Acme::Client.new(private_key: OpenSSL::PKey::RSA.new(2048), endpoint: options[:endpoint])

    puts 'Registering with Let\'s Encrypt service...'
    registration = client.register(contact: "mailto:#{options[:contact_email]}")
    if registration.agree_terms
      puts 'Success'
    else
      puts 'Failed'
      return
    end

    puts 'Sending authorization request(s)...'
    options[:domains].each do |domain|
      authorization = client.authorize(domain: domain)
      challenge = authorization.http01

      puts ''
      puts 'Set'
      puts "LE_HTTP_CHALLENGE_RESPONSE=#{challenge.file_content}"
      puts 'on your Rails web server and restart it.'
      puts ''
      puts 'You can test by pointing your browser to'
      puts "#{domain}/#{challenge.filename}"
      puts ''

      puts 'Looking good?'
      press_any_key

      puts 'Requesting verification...'
      challenge.request_verification
      sleep(1) while 'pending' == challenge.verify_status

      puts "Validation failed for #{domain}" unless 'valid' == challenge.verify_status
    end

    puts ''
    puts 'Requesting the certificate...'
    csr = Acme::CertificateRequest.new(names: options[:domains])
    certificate = client.new_certificate(csr)

    if certificate.nil?
      puts 'Failed to obtain certificate'
    else
      File.write('privkey.pem', certificate.request.private_key.to_pem)
      File.write('cert.pem', certificate.to_pem)
      File.write('chain.pem', certificate.chain_to_pem)
      File.write('fullchain.pem', certificate.fullchain_to_pem)
      puts 'Certificate saved'
    end
  end

  def press_any_key
    puts 'Press any key to continue.'
    STDIN.getch
  end

  generate_cert(options)

end