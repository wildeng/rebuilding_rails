# rulers/lib/rulers/view.rbi
require 'erubis'

module Rulers
  class View
    def initialize(controller_name, view_name, env, instance_vars)
      @controller_name = controller_name
      @instance_vars = instance_vars
      instance_vars.each do |var|
        name = "@#{var[0]}"
        instance_variable_set(name.to_sym, var[1])
      end
      @env = env
      @view_name = view_name
    end

    def get_binding
      binding
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
