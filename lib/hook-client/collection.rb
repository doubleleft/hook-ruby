module Hook
  class Collection

    def initialize options = {}
      @name = options.delete(:name)
      @client = options.delete(:client) || Hook::Client.instance

      segment = options.delete(:channel) ? "channel" : "collection"
      @segments = "#{segment}/#{@name}"
      reset!
    end

    # Find item by _id.
    #
    # @param _id [String]
    # @return [Hash]
    def find _id
      if _id.kind_of?(Array)
        self.where(:_id.in => _id).all
      else
        @client.get "#{@segments}/#{_id}"
      end
    end

    # Return only the first result from the database
    def first
      @options[:first] = 1
      self.query!
    end

    # Create an item into the collection
    #
    # @param data [Hash, Array] item or array of items
    # @return [Hash, Array]
    def create data
      if data.kind_of?(Array)
        # TODO: server should accept multiple items to create,
        # instead of making multiple requests.
        data.map {|item| self.create(item) }
      else
        @client.post @segments, data
      end
    end

    # Retrieve the first item with the given params in the database,
    # if not found this will create one.
    #
    # @param data [Hash] query and data to store
    # @return [Hash]
    def first_or_create data
      @options[:first] = 1
      @options[:data] = data
      @client.post(@segments, self.build_query)
    end

    # Remove items by id, or by query
    #
    # @param _id [String, nil] _id
    # @return [Hash] status of the operation (ex: {success: true, affected_rows: 7})
    def remove _id = nil
      path = @segments
      path = "#{path}/#{_id}" if _id
      @client.remove(path, build_query)
    end

    # Remove items by query. This is the same as calling `remove` without `_id` param.
    # @see remove
    def delete_all
      self.remove(nil)
    end

    # Add where clause to the current query.
    #
    # Supported modifiers on fields: .gt, .gte, .lt, .lte, .ne, .in, .not_in, .nin, .like, .between, .not_between
    #
    # @param fields [Hash] fields and values to filter
    # @param [String] operation (and, or)
    #
    # @example
    #     hook.collection(:movies).where({
    #       :name => "Hook",
    #       :year.gt => 1990
    #     })
    #
    # @example Using Range
    #     hook.collection(:movies).where({
    #       :name.like => "%panic%",
    #       :year.between => 1990..2014
    #     })
    #
    # @return [Collection] self
    def where fields = {}, operation = 'and'
      fields.each_pair do |k, value|
        field = (k.respond_to?(:field) ? k.field : k).to_s
        operation = k.respond_to?(:operation) ? k.operation : '='

        # Range syntatic sugar
        value = [ value.first, value.last ] if value.kind_of?(Range)

        @wheres << [field, operation, value, operation]
      end
      self
    end

    # Add where clause with 'OR' operation to the current query.
    # @param fields [Hash] fields and values to filter
    # @return [Collection] self
    def or_where fields = {}
      self.where(fields, 'or')
    end

    # Add order clause to the query.
    #
    # @param fields [String] ...
    # @return [Collection] self
    def order fields
      by_num = { 1 => 'asc', -1 => 'desc' }
      ordering = []
      fields.each_pair do |key, value|
        ordering << [key.to_s, by_num[value] || value]
      end
      @ordering = ordering
      self
    end
    alias_method :sort, :order

    # Limit the number of results to retrieve.
    #
    # @param int [Integer]
    # @return [Collection] self
    def limit int
      @limit = int
      self
    end

    # @param int [Integer]
    # @return [Collection] self
    def offset int
      @offset = int
      self
    end

    # Run the query, and return all it's results.
    # @yield You may use a block with all returned results
    # @return [Array]
    def all(&block)
      rows = query!
      yield rows if block_given?
      rows
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

    # Specify the target field names to retrieve
    #
    # @param fields [String] ...
    # @return [Collection] self
    def select *fields
      @options[:select] = fields
    end

    # Return related collection's data
    #
    # @param relationships [String] ...
    #
    # @example Retrieving a single relation
    #     hook.collection(:books).with(:publisher).each do |book|
    #       puts book[:name]
    #       puts book[:publisher][:name]
    #     end
    #
    # @example Retrieving multiple relations
    #     hook.collection(:books).with(:publisher, :author).each do |book|
    #       puts book[:name]
    #       puts book[:publisher][:name]
    #       puts book[:author][:name]
    #     end
    #
    # @return [Collection] self
    def with *relationships
      @options[:with] = relationships
      self
    end

    # Group query results
    # @param fields [String] ...
    # @return [Collection] self
    def group *fields
      @group = fields
      self
    end

    def count field = '*'
      @options[:aggregation] = { :method => 'count', :field => field }
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

    protected

    def reset!
      @wheres = []
      @options = {}
      @wheres = []
      @ordering = []
      @group = []
      @limit = nil
      @offset = nil
    end

  end
end
