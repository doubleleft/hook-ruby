require 'http'
require 'ostruct'

module DL
  class Client
    class << self
      attr_reader :instance
      def configure(options = {})
        @instance = self.new(options)
      end
    end

    def initialize options = {}
      @app_id = options.delete(:app_id)
      @key = options.delete(:key)
      @endpoint = options.delete(:endpoint) || options.delete(:url)
    end

    def keys
      Keys.new
    end

    def auth
      Auth.new
    end

    def files
      Files.new
    end

    def collection(name)
      Collection.new(:name => name, :client => self)
    end

    def channel
    end

    def post segments, data
      request :post, segments, data
    end

    def get segments, data = {}
      request :get, segments, data
    end

    def put segments, data
      request :put, segments, data
    end

    def remove segments
      request :delete, segments
    end
    alias_method :delete, :remove

    protected
    def request method, segments, data = {}
      headers = {
        :accept => 'application/json',
        'X-App-Id' => @app_id,
        'X-App-Key' => @key
      }
      response = HTTP.with(headers).send method, "#{@endpoint}/#{segments}", :json => data
      OpenStruct.new(JSON.parse(response.to_s))
    end

  end
end
