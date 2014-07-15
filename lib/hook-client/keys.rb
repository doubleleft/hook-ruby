module Hook
  class Keys

    def initialize(options={})
      @client = options.delete(:client) || Hook::Client.instance
    end

    def get(key)
      response = @client.get("key/#{key}");
      (!response.empty?) ? response['value'] : nil
    end

    def set(key, value)
      @client.post("key/#{key}", { :value => value });
    end

  end
end