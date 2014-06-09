module DL
  module Extensions
    module Symbol

      {
        :gt => '>',
        :gte => '>=',
        :lt => '<',
        :lte => '<=',
        :ne => '!=',
        :in => 'in',
        :not_in => 'not_in',
        :nin => 'not_in', # alias
        :like => 'like',
        :between => 'between',
        :not_between => 'not_between',
        # :max_distance,
      }.each_pair do |method, operation|
        define_method(method) do
          OpenStruct.new(:field => self, :operation => operation)
        end
      end

    end
  end
end

::Symbol.__send__(:include, DL::Extensions::Symbol)
