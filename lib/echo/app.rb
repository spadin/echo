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
       if not_modified_status_code?
          {}
       elsif headers_from_params?
          parsed_headers_from_params
       else
          json_content_type_header
       end
    end

    def json_content_type_header
       {'Content-Type' => 'application/json'}
    end

    def parsed_headers_from_params
       JSON.parse(headers_from_params)
    end

    def headers_from_params
       params['header'] || '{}'
    end

    def headers_from_params?
       !params['header'].nil?
    end

    def not_modified_status_code?
       status_code == 304
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

    def params
       request.params
    end

    def json_params
      params.to_json
    end

    def request
      Rack::Request.new(env)
    end
  end
end
