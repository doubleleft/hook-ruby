require 'http'
require 'uri'

module Hook
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
      @endpoint = "#{@endpoint}/" unless @endpoint.end_with? "/"

      @logger = options.delete(:logger)
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

    def logger=(logger)
      @logger = logger
    end

    def channel
      throw RuntimeError.new('Not implemented.')
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

    def remove segments, data = {}
      request :delete, segments, data
    end
    alias_method :delete, :remove

    protected
    def request method, segments, data = {}
      response = nil, headers = {
        :accept => 'application/json',
        'X-App-Id' => @app_id,
        'X-App-Key' => @key
      }

      if method == :get
        segments = "#{segments}?#{URI::escape(data.to_json)}"
        data = nil
      end

      if @logger
        start_time = Time.now
      end

      response = HTTP.with(headers).send(method, "#{@endpoint}#{segments}", :json => data).to_s

      if @logger
        @logger.info "#{self.class.name} - #{(Time.now - start_time).round(3)}s - #{method.upcase} #{@endpoint}#{segments}"
      end

      # If JSON.parse don't suceed, return response as integer
      JSON.parse(response) rescue response.to_i
    end

  end
end
