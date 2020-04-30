# rulers/lib/rulers/controller.rb
require 'erubis'

module Rulers
  class Controller
    def initialize(env)
      @env = env
    end

    def env
      @env
    end

		def instance_variables
			vars = {}
			self.instance_variables.each do |attribute|
				vars[attribute[1..-1]] = instance_variable_get(attribute.to_sym)
			end
			vars
		end

		def controller_name
			klass = self.class
			klass = klass.to_s.gsub(/Controller$/,"")
			Rulers.to_underscore klass
		end
	
		def render(view_name, locals = instance_variables)
			filename = File.join "app", "views",
				controller_name, "#{view_name}.html.erb"
			template = File.read filename
			eruby = Erubis::Eruby.new(template)
			eruby.result locals.merge(env: env)
		end
  end
end

