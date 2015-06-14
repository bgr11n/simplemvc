require "simplemvc/version"

module Simplemvc
  class App
    def call(env)
      [200, {"Content-type" => "text/html"}, ["Hello"]]
    end
  end
end
