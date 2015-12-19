require 'test_helper'

module LetsencryptHttpChallenge
  class ApplicationControllerTest < ActionController::TestCase
    setup do
      @routes = LetsencryptHttpChallenge::Engine.routes
    end

    test "matching challenge token returns the challenge response" do
      get :index, challenge: '58u1GLEGwgSbK-3LnTYUDwZySN3FmTxE4CuqAf8IpAU'
      assert_response :success
      assert_match('58u1GLEGwgSbK-3LnTYUDwZySN3FmTxE4CuqAf8IpAU.VDnmZ7G7W4pPpHL_rTLA9SUPSN0qTwe876q2C2gpLLs', response.body)
    end

    test "token must match" do
      get :index, challenge: '58u1GLEGwgSbK-3LnTYUDwZySN3FmTxE4CuqAf8IpAU_wrong_token'
      assert_response :bad_request
      assert_match('token must match between', response.body)
    end

    test "token must be longer than 128 bits" do
      get :index, challenge: '58u1GLEG'
      assert_response :bad_request
      assert_match('token must have at least 128 bits', response.body)
    end
  end
end
