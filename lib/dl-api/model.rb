module DL
  #
  # Provides ActiveRecord/like methods for querying Collections
  #
  module Model
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
    end
  end
end
