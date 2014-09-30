module Hook
  module Channel
    autoload :SSE, 'hook-client/channel/sse'
    autoload :WEBSOCKET, 'hook-client/channel/websocket'

    def self.create(client, name, options = {})
      channel_klass = (options.delete(:transport) || 'sse').upcase
      collection = Collection.new(name, :channel => true)
      self.const_get(channel_klass).new(client, collection, options)
    end

  end
end
