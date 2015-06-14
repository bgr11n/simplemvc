require "slim"

module Simplemvc
  class Controller
    attr_reader :request

    def initialize env
      @request ||= Rack::Request.new env
    end

    def params
      @request.params
    end

    def response body, status = 200, header = {}
      @response = Rack::Response.new body, status, header
    end

    def get_response
      @response
    end

    def render *args
      response render_template(*args)
    end

    def render_template view_name, locals = {}
      filename = File.join("app", "views", controller_name, "#{view_name}.slim")

      vars = {}

      instance_variables.each do |v|
        key = v.to_s.gsub("@", "").to_sym
        vars[key] = instance_variable_get(v)
      end

      Slim::Template.new(filename).render(Object.new, locals.merge(vars))
    end

    def controller_name
      self.class.to_s.gsub(/Controller$/, "").to_snake_case
    end

    def dispatch action
      content = self.send(action)
      if get_response
        get_response
      else
        render(action)
        get_response
      end
    end

    def self.action action_name
      -> (env) { self.new(env).dispatch(action_name) }
    end
  end
end
