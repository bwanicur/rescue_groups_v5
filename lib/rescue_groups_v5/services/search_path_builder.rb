# frozen_string_literal: true

module RescueGroupsV5
  module Services
    class SearchPathBuilder
      def self.run(base_path, views, valid_views)
        view_names = Array(views).map(&:to_s)
        invalid = view_names - valid_views
        if invalid.any?
          raise InvalidViewError, "Invalid view(s): #{invalid.join(', ')}. Valid views: #{valid_views.join(', ')}"
        end

        ["#{base_path}/search", *view_names].join("/")
      end
    end
  end
end
