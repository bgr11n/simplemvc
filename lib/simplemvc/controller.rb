require "slim"

module Simplemvc
  class Controller
    def render view_name, locals = {}
      filename = File.join("app", "views", controller_name, "#{view_name}.slim")
      Slim::Template.new(filename).render(Object.new, locals)
    end

    def controller_name
      self.class.to_s.gsub(/Controller$/, "").to_snake_case
    end
  end
end
