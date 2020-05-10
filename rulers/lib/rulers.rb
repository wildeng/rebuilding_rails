# rulers/lib/rulers.rb
require 'rulers/array'
require 'rulers/version'
require 'rulers/routing'
require 'rulers/dependencies'
require 'rulers/util'
require 'rulers/controller'
require 'rulers/file_model'
require 'rulers/view'

module Rulers
  class Application
    def call(env)
      if env['PATH_INFO'] == '/favicon.ico'
      	return [404, {'Content-Type' => 'text/html'}, []]
      end

      if env['PATH_INFO'] == '/'
        return [302, {'Content-Type' => 'text/html'},
	        ["<p>This page is currently unavailable</p>"]
	      ]
      end
      klass, act = get_controller_and_action(env)
      controller = klass.new(env)
      raise RuntimeError if act == 'update' && env['REQUEST_METHOD'] != 'POST'
      text = controller.send(act)
      resp = controller.get_response
      if resp
        [resp.status, resp.headers, [resp.body].flatten ]
      else
        [200, {'Content-Type' => 'text/html'}, [text]]
      end
    rescue RuntimeError
      [500, {'Content-Type' => 'text/html'}, ["Pretty wild hu?"]]
    end
  end
end
