require 'active_model'

module DL
  #
  # Provides ActiveRecord/like methods for querying Collections
  #
  module Model
    def self.included(base)
      base.class_eval do
        extend ClassMethods
        extend ActiveModel::Naming
        extend ActiveModel::Translation
        extend ActiveModel::Callbacks
        include ActiveModel::Validations
        include ActiveModel::Conversion
        include ActiveModel::Dirty
        include ActiveModel::AttributeMethods
        include ActiveModel::Serializers::JSON
        include ActiveModel::Serializers::Xml

        field :_id
      end
    end

    module InstanceMethods
      def initialize(attrs = {})
        @collection = DL::Client.instance.collection(self.class.collection_name)
        self.attributes = {}
        attrs.each_pair do |name, value|
          self.send(:"#{name}=", value) if self.respond_to?(:"#{name}")
        end

        # reset_changes
        changes_applied if self._id
      end

      def save
        return false unless self.changed?

        changes_applied
        if self._id.nil?
          self.attributes = @collection.update(self._id, attributes)
        else
          self.attributes = @collection.create(attributes)
        end
        self
      end

      def attributes=(attrs)
        @attributes = attrs
      end

      def attributes
        @attributes
      end

      def inspect
        "#<#{self.class.name}: attributes=#{attributes.inspect}>"
      end

      # Delegator methods
      def method_missing(m, *args, &block)
        res = @collection.send(m, *args, &block)

        # Check for success/error responses
        if res.kind_of?(Hash) && res.length == 1
          return res['success'] unless res['success'].nil?
          throw RuntimeError.new(res['error']) unless res['error'].nil?
        end

        if (res.kind_of?(DL::Collection))
          self
        else
          (res.kind_of?(Array)) ? res.map {|r| self.class.new(r) } : self.class.new(res)
        end
      end

    end

    module ClassMethods
      def collection_name(name = nil)
        if name
          @collection_name = name
        else
          @collection_name = ActiveModel::Naming.route_key(self)
        end
      end

      def field name, options = {}
        define_attribute_method name

        # Define getter
        define_method name do
          # self.instance_variable_get("@#{name}")
          attributes[name]
        end

        # Define setter
        define_method "#{name}=" do |value|
          self.send(:"#{name}_will_change!")
          attributes[name] = value
        end
      end

      def method_missing(m, *args, &block)
        instance = self.new
        instance.send(m, *args, &block)
      end
    end

    include InstanceMethods
  end
end
