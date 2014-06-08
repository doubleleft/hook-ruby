module DL
  module Extensions
    autoload :Symbol, 'dl-api/extensions/symbol'

    def self.eager_load!
      self.constants.each {|const| self.const_get(const) }
    end
  end
end

# Load all the extensions
DL::Extensions.eager_load!
