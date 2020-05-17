# rulers/lib/rulers/view.rbi
require 'erubis'

module Rulers
  class View
    def initialize(controller_name, view_name, env, instance_vars, locals)
      @controller_name = controller_name
      @instance_vars = instance_vars
      instance_vars.each do |var|
        name = "@#{var[0]}"
        instance_variable_set(name.to_sym, var[1])
      end
      @env = env
      @locals = locals
      @view_name = view_name
    end

    def get_binding
      bind = binding
      @locals.each do |key, value|
        bind.local_variable_set(key, value)
      end
      bind
    end

    def render
      filename = File.join "app", "views",
        @controller_name, "#{@view_name}.html.erb"
      template = File.read filename
      eruby = Erubis::Eruby.new(template)
      eruby.result get_binding
    end
  end
end
