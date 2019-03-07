module RescueGroupsV5
  module Requests
    class Base
      PUBLIC_URL = Config.read(:public_url) || 'https://api.rescuegroups.org/v5/'

      def get_request(path, opts = {})
        # PUBLIC_URL + path
        # TODO
      end

      def post_request(path, opts = {})
        # PUBLIC_URL + path
        # TODO
      end

      def connection
        @connection ||= Faraday.new
      end

      def headers(opts = {})
        connection.headers.merge({
          'Content-Type' => 'application/json',
          'Authorization' => Config.read(:api_key),
        }).merge(opts)
      end

      private

      # TODO: each one of these methods might need to consume a service

      def includes_str(includes = [])
        # TODO: not sure - wait until V5 API is updated
      end

      def sort_str(opts = {})
        # TODO: not sure - wait until V5 API is updated
      end

      def fields_str(fields = [])
        # TODO: not sure - wait until V5 API is updated
      end

      def filters_data(opts = {})
        {
          filters: FilterBuilder.transform_filters(opts[:filters]) || [],
          filterRadius: {
            zipcode: opts[:zipcode],
            miles: opts[:radius_in_miles]
          }
        }
      end
    end
  end
end
