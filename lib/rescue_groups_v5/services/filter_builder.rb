module RescueGroupsV5
  module Services
    class FilterBuilder
      OPERATIONS = {
        equals:                :equals,
        not_equal:             :notequal,
        less_than:             :lessthan,
        less_than_or_equal:    :lessthanorequal,
        greater_than:          :greaterthan,
        greater_than_or_equal: :greaterthanorequal,
        contains:              :contains,
        not_contain:           :notcontain,
        blank:                 :blank,
        not_blank:             :notblank
      }

      def self.transform_filters(filters_data)
        filters = []
        filters_data.each do |field_name, filter_metadata|
          if filter_metadata.is_a?(String) || filter_metadata.is_a?(Integer)
            operation = OPERATIONS[:equals]
            value = filter_metadata
          else
            operation = filter_metadata[:operation]
            value = filter_metadata[:value]
          end
          filters << {
            fieldName: field_name,
            operation: translate_operation(operation),
            criterion: value
          }
        end
        filters
      end

      private

      def self.translate_operation(operation_key)
        OPERATIONS[operation_key]
      end
    end
  end
end
