module RescueGroupsV5
  module Services
    class FilterBuilder
      OPERATIONS = {
        equals:                'equals',
        not_equal:             'notequal',
        less_than:             'lessthan',
        less_than_or_equal:    'lessthanorequal',
        greater_than:          'greaterthan',
        greater_than_or_equal: 'greaterthanorequal',
        contains:              'contains',
        not_contain:           'notcontain',
        blank:                 'blank',
        not_blank:             'notblank'
      }.freeze

      def self.run(filters_data)
        filters_data.map do |hash|
          operation = hash[:operation] || OPERATIONS[:equals]
          {
            fieldName: "#{hash[:object].to_s}.#{hash[:field_name].to_s}",
            operation: translate_operation(operation),
            criteria: hash[:criteria]
          }
        end
      end

      private

      def self.translate_operation(operation_key)
        OPERATIONS[operation_key.to_sym]
      end
    end
  end
end
