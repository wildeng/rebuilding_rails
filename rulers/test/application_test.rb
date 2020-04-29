# rulers/test/application_test.rb
require_relative "test_helper"

class TestController < Rulers::Controller
	def index
		'Hello' # not rendering any view
	end

	def hello_world_html
		'Hello HTML'
	end

	def hello_world_xml
		'Hello XML'
	end
end

class TestApp < Rulers::Application
end

class RulersAppTest < Minitest::Test
  include Rack::Test::Methods

  def app
    TestApp.new
  end

	def test_route_request
		get 'test/index'

		assert last_response.ok?
		puts last_response.inspect
		body = last_response.body
		assert body['Hello']
	end
  
	def test_html_request
		get 'test/hello_world_html'

		assert last_response.ok?
		body = last_response.body
		assert body['Hello HTML']
	end
  
	def test_xml_request
		get 'test/hello_world_xml'

		assert last_response.ok?
		body = last_response.body
		assert body['Hello XML']
	end

  def test_get_request
    get '/'

    assert_equal 302, last_response.status
  end

  def test_post_request
    post '/'

    assert_equal 302, last_response.status
  end
end
