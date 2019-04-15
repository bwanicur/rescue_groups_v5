module RescueGroupsV5
  module Services
    class FieldsBuilder
      def self.run(data)
        fields_strs = []
        data.each do |field_name, attributes|
          fields_strs << "fields[#{field_name}]=#{attributes.join(',')}"
        end
        fields_strs.join('&')
      end
    end
  end
end
