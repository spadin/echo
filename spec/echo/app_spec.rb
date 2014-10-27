require 'rack/mock'
require 'echo/app'

describe Echo::App do
  let(:app) { described_class.new }

  context 'headers' do
    it 'returns a content-type of application/json' do
      _, headers, _ = app.call(create_rack_env)
      expect(headers['Content-Type']).to eq('application/json')
    end
  end

  context 'body' do
    it 'returns and empty object when no params are passed' do
      _, _, body = app.call(create_rack_env)
      expect(body.join).to eq('{}')
    end

    it 'returns the params as json' do
      env = create_rack_env('/', params: 'key=value')
      _, _, body = app.call(env)
      expect(body.join).to eq('{"key":"value"}')
    end
  end

  context 'status' do
    it 'returns a 200 status' do
      env = create_rack_env('/')
      status, _, _ = app.call(env)
      expect(status).to eq(200)
    end

    it 'returns the status as 404' do
      env = create_rack_env('/404')
      status, _, _ = app.call(env)
      expect(status).to eq(404)
    end
  end

  def create_rack_env(url = '/', opts={})
    Rack::MockRequest.env_for(url, opts)
  end
end
