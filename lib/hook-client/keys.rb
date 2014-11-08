module Hook
  class Keys

    def initialize(options={})
      @client = options.delete(:client) || Hook::Client.instance
    end

    # Return the unserialized value
    #
    # @param key [String, Symbol]
    # @return [Object] value
    def get(key)
      @client.get("key/#{key}")
    end

    # Store serialized value
    #
    # @param key [String, Symbol] key
    # @param value [Object] JSON serializable object
    # @return [Object] The object you just stored.
    def set(key, value)
      @client.post("key/#{key}", { :value => value });
    end

  end
end
