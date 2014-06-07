require 'http'

module DL
  class API
    class << self
      def configure(options = {})
        @client = self.new(options)
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
      Collection.new(name)
    end

    def channel
    end

    def post segments
      request :post, segments
    end

    def get segments
      request :get, segments
    end

    def put segments
      request :put, segments
    end

    alias_method :delete, :remove
    def remove(segments)
      request :delete, segments
    end

    protected
    def request method, segments, data
      HTTP.with({
        :accept => 'application/json',
        'X-App-Id' => @app_id,
        'X-App-Key' => @key
      }).send method, "#{@endpoint}/#{segments}", :json => data
    end

  end
end
