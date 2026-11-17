# frozen_string_literal: true

module RescueGroupsV5
  module Services
    class RadiusFilterBuilder
      DEFAULT_RADIUS_MILES = 10

      def self.run(data)
        if data[:postalcode]
          { "postalcode" => data[:postalcode] }.merge(distance_info(data))
        elsif data[:lat] && data[:lon]
          { "lat" => data[:lat], "lon" => data[:lon] }.merge(distance_info(data))
        end
      end

      def self.distance_info(data)
        if data[:kilometers]
          { "kilometers" => data[:kilometers] }
        else
          { "miles" => data[:miles] || DEFAULT_RADIUS_MILES }
        end
      end
      private_class_method :distance_info
    end
  end
end
