# frozen_string_literal: true

module RescueGroupsV5
  module Services
    class SortBuilder
      def self.run(sort_data)
        sort_strings = []
        sort_data.each do |hash|
          dir = hash[:direction] == :descending ? "-" : ""
          sort_strings << "#{hash[:object]}.#{hash[:sort_value]}#{dir}"
        end
        sort_strings.join(",")
      end
    end
  end
end
