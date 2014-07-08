module Hook
  module Extensions
    autoload :Symbol, 'hook-client/extensions/symbol'

    def self.eager_load!
      self.constants.each {|const| self.const_get(const) }
    end
  end
end

# Load all the extensions
Hook::Extensions.eager_load!
