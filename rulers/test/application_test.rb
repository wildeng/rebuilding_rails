# rulers/test/application_test.rb
require_relative "test_helper"

class TestApp < Rulers::Application
end

class RulersAppTest < Minitest::Test
  include Rack::Test::Methods

  def app
    TestApp.new
  end

  def test_get_request
    get '/'

    assert_equal 302, last_response.status
  end

  def test_post_request
    post '/'

    assert_equal 302, last_response.status
  end

  #def test_get_not_found
  #  get '/unknown_path'

   # assert_equal 404, last_response.status
  #end

  #def test_post_not_found
  #  post '/unknown_path'

   # assert last_response.status == 404
  #end
end
