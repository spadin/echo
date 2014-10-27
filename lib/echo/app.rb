require 'rack/request'
require 'json'

module Echo
  class App
    def call(env)
      @env = env
      [status_code, header, body]
    end

    private

    attr_reader :env

    def header
      {'Content-Type' => 'application/json'}
    end

    def status_code
      status_code_from_path_as_int || 200
    end

    def status_code_from_path_as_int
      status_code_from_path.to_i if status_code_from_path
    end

    def status_code_from_path
      request.path.split("/")[1]
    end

    def body
      [json_params]
    end

    def json_params
      request.params.to_json
    end

    def request
      Rack::Request.new(env)
    end
  end
end
