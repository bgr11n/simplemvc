module Simplemvc
  class Router
    def initialize
      @routes = []
    end

    def match url, *args
      target = args.shift if args.size > 0

      @routes << {
        regexp: Regexp.new("^#{url}$"),
        target: target
      }
    end

    def check_url url
      @routes.each do |r|
        match = r[:regexp].match(url)
        if match
          if r[:target] =~ /^([^#]+)#([^#]+)$/
            controller_name = $1.to_camel_case
            controller = Object.const_get("#{controller_name}Controller")
            return controller.action($2)
          end
        end
      end
    end
  end

  class App
    def route &block
      @router ||= Simplemvc::Router.new
      @router.instance_eval &block
    end

    def get_rack_app env
      @router.check_url(env["PATH_INFO"])
    end
  end
end
