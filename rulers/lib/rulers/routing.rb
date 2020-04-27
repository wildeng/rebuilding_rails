# rulers/lib/rulers/routing.rb

module Rulers
  class Application
    def get_controller_and_action(env)
      _, cont, action, after =
        env['PATH_INFO'].split('/', 4)
      cont = cont.capitalize # get the controller name
      cont += 'Controller' # get the controller class name

      [Object.const_get(cont), action] 
    end
  end
end
