# rulers/lib/rulers/controller.rb
require 'erubis'
require 'rulers/file_model'
require 'rulers/view'

module Rulers
  class Controller
    include Rulers::Model

    def initialize(env)
      puts env.inspect
      @env = env
    end

    def env
      @env
    end

    def instance_vars
      vars = {}
      instance_variables.each do |name|
        vars[name[1..-1]] = instance_variable_get name.to_sym
      end
      vars
    end

    def request
      @request ||= Rack::Request.new(@env)
    end

    def action
      @request.env['REQUEST_PATH'].split('/').last
    end

    def params
      request.params
    end

    def controller_name
      klass = self.class
      klass = klass.to_s.gsub(/Controller$/,"")
      Rulers.to_underscore klass
    end

    def render(view_name, locals = instance_vars)
      filename = File.join "app", "views",
        controller_name, "#{view_name}.html.erb"
      template = File.read filename
      eruby = Erubis::Eruby.new(template)
      eruby.result locals.merge(env: env)
    end

    def response(text, status = 200, headers = {})
      raise 'already responded' if @response
      a = [text].flatten
      @response = Rack::Response.new(a, status, headers)
    end
    
    def get_response
      @response
    end

    def render_response(*args)
      locals = {}
      view_name = action if args.empty?
      unless args.empty?
        view_name = args[0] 
        locals = args[1]
      end
      response(
        View.new(
          controller_name, view_name, env, instance_vars, locals
        ).render
      )
    end
  end
end
