LetsencryptHttpChallenge::Engine.routes.draw do
  get '.well-known/acme-challenge/:challenge' => 'application#index' unless ENV['LE_HTTP_CHALLENGE_RESPONSE'].blank?
end
