module Hook
  class Collection

    def initialize options = {}
      @name = options.delete(:name)
      @client = options.delete(:client) || Hook::Client.instance
      @segments = "collection/#{@name}"
      reset!
    end

    def reset!
      @wheres = []
      @options = {}
      @wheres = []
      @ordering = []
      @group = []
      @limit = nil
      @offset = nil
    end

    def find _id
      if _id.kind_of?(Array)
        self.where(:_id.in => _id).all
      else
        @client.get "#{@segments}/#{_id}"
      end
    end

    def first
      @options[:first] = 1
      self.query!
    end

    def create data
      if data.kind_of?(Array)
        # TODO: server should accept multiple items to create,
        # instead of making multiple requests.
        data.map {|item| self.create(item) }
      else
        @client.post @segments, data
      end
    end

    def remove _id = nil
      path = @segments
      path = "#{path}/#{_id}" if _id
      @client.remove(path, build_query)
    end

    def delete_all
      self.remove(nil)
    end

    def where options = {}, operation = 'and'
      options.each_pair do |k, value|
        field = (k.respond_to?(:field) ? k.field : k).to_s
        operation = k.respond_to?(:operation) ? k.operation : '='

        # Range syntatic sugar
        value = [ value.first, value.last ] if value.kind_of?(Range)

        @wheres << [field, operation, value, operation]
      end
      self
    end

    def or_where options = {}
      self.where(options, 'or')
    end

    def order fields
      by_num = { 1 => 'asc', -1 => 'desc' }
      ordering = []
      fields.each_pair do |key, value|
        ordering << [key.to_s, by_num[value] || value]
      end
      @ordering = ordering
    end
    alias_method :sort, :order

    def limit int
      @limit = int
    end

    def offset int
      @offset = int
    end

    def all
      query!
    end

    def query!
      @client.get @segments, build_query
    end

    def method_missing method, *args, &block
      if Enumerator.method_defined? method
        Enumerator.new(self.all).send(method, args, block)
      end

      throw NoMethodError.new("#{self.class.name}: method '#{method}' not found")
    end

    def select *fields
      @options[:select] = fields
    end

    def with *relationships
      @options[:with] = relationships
    end

    def group *fields
      @group = fields
    end

    def count
      @options[:aggregation] = { :method => 'count', :field => nil }
      self.query!
    end

    def max field
      @options[:aggregation] = { :method => :max, :field => field }
      self.query!
    end

    def min field
      @options[:aggregation] = { :method => :min, :field => field }
      self.query!
    end

    def avg field
      @options[:aggregation] = { :method => :avg, :field => field }
      self.query!
    end

    def sum field
      @options[:aggregation] = { :method => :sum, :field => field }
      self.query!
    end

    def increment field, value = 1
      @options[:operation] =  { :method => 'increment', :field => field, :value => value }
      self.query!
    end

    def decrement field, value = 1
      @options[:operation] =  { :method => 'decrement', :field => field, :value => value }
      self.query!
    end

    def update _id, data
      @client.post "#{@segments}/#{_id}", data
    end

    def update_all data
      @options[:data] = data
      @client.put @segments, build_query
    end

    def build_query
      query = {}
      query[:limit] = @limit if @limit
      query[:offset] = @offset if @offset

      query[:q] = @wheres unless @wheres.empty?
      query[:s] = @ordering unless @ordering.empty?
      query[:g] = @group unless @group.empty?

      {
        :paginate => 'p',
        :first => 'f',
        :aggregation => 'aggr',
        :operation => 'op',
        :data => 'data',
        :with => 'with',
        :select => 'select',
      }.each_pair do |option, shortname|
        query[ shortname ] = @options[ option ] if @options[ option ]
      end

      self.reset!
      query
    end

    # firstOrCreate = function(data)
    # channel = function(options)
    # drop = function()
    # remove = function(_id)

  end
end

