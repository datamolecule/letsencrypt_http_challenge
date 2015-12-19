Rails.application.routes.draw do

  mount LetsencryptHttpChallenge::Engine => "/"
end
