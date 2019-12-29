# frozen_string_literal: true

module RescueGroupsV5
  module Services
    class FilterBuilder
      OPERATIONS = {
        equals:                "equals",
        not_equal:             "notequal",
        less_than:             "lessthan",
        less_than_or_equal:    "lessthanorequal",
        greater_than:          "greaterthan",
        greater_than_or_equal: "greaterthanorequal",
        contains:              "contains",
        not_contain:           "notcontain",
        blank:                 "blank",
        not_blank:             "notblank"
      }.freeze

      def self.run(filters_data)
        filters_data.map do |hash|
          operation = hash[:operation] || OPERATIONS[:equals]
          {
            fieldName: "#{hash[:object]}.#{hash[:field_name]}",
            operation: translate_operation(operation),
            criteria: hash[:criteria]
          }
        end
      end

      def self.translate_operation(operation_key)
        OPERATIONS[operation_key.to_sym]
      end
      private_class_method :translate_operation
    end
  end
end
