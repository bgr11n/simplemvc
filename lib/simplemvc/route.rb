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
      puts @routes.inspect
      @routes.each do |r|
        puts '1'
        match = r[:regexp].match url
        if match
          puts '2'
          if r[:target] =~ /^([^#]+)#([^#]+)$/
            puts '3'
            controller_name = $1.to_camel_case
            controller = Object.get_const("#{controller_name}Controller")
            return controller.action($2)
          end
        end
      end
    end
  end

  class App
    def initialize
      @router = Simplemvc::Router.new
    end

    def route &block
      @router.instance_eval &block
    end

    def get_rack_app env
      @router.check_url(env["PATH_INFO"])
    end
  end
end
