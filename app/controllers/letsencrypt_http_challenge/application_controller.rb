module LetsencryptHttpChallenge
  class ApplicationController < ActionController::Base

    def index
      challenge = params[:challenge].to_s
      response = ENV['LE_HTTP_CHALLENGE_RESPONSE'].to_s
      status = :ok

      # https://letsencrypt.github.io/acme-spec/#rfc.section.7.1

      # token (required, string): This value MUST have at least 128 bits of entropy
      if challenge.length < 16
        response = 'Challenge failed - The token must have at least 128 bits of entropy'
        Rails.logger.error response
        status = :bad_request

      # its “token” field is equal to the “token” field in the challenge;
      elsif response.match(challenge).nil?
        response = 'Challenge failed - The token must match between the challenge and the response'
        Rails.logger.error response
        status = :bad_request
      end

      render plain: response, status: status
    end
  end
end
