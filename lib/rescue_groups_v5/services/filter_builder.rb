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

      def self.run(filters_data)
        filters_data.map do |hash|
          operation = hash[:operation] || OPERATIONS[:equals]
          {
            fieldName: "#{hash[:object]}.#{hash[:field_name]}",
            operation: translate_operation(operation),
            criterion: hash[:value]
          }
        end
      end

      private

      def self.translate_operation(operation_key)
        OPERATIONS[operation_key].to_s
      end
    end
  end
end
