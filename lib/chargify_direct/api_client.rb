require 'faraday'
require 'chargify_direct/client'
require 'chargify_direct/defaults'

module ChargifyDirect
  class ApiClient < Client
    include Defaults

    def get(path, params = {})
      request(:get, path, params)
    end

    def post(path, params = {})
      signature_params = params.values.any? { |value| value.respond_to?(:to_io)} ? {} : params
      request(:post, path, params, signature_params)
    end

    private

    def connection
      @connection ||= Faraday.new(API_ENDPOINT, connection_options) do |conn|
        conn.basic_auth(api_id, api_password)
      end
    end

    def request(method, path, params = {})
      response = connection.send(method.to_sym, path) do |request|
        request.params.update(params)
      end
    end
  end
end