require 'faraday'
require 'json'
require_relative '../services/filter_builder'

module RescueGroupsV5
  module Requests
    class Request
      URL = 'https://api.rescuegroups.org/v5/public'.freeze

      def initialize(api_key, connection: nil)
        @conn = connection || Faraday.new(url: URL)
        @api_key = api_key
      end

      def get(path, opts = {})
        base_request(:get, path, opts)
      end

      def post(path, opts = {})
        base_request(:post, path, opts)
      end

      private

      def base_request(verb, path, opts)
        res = @conn.send(verb, path) do |req|
          req.headers['Content-Type'] = 'application/json'
          req.headers['Authorization'] = @api_key
          req.params['fields'] = fields_str(opts[:fields]) if opts[:fields]
          req.params['includes'] = includes_str(opts[:includes]) if opts[:includes]
          req.params['sort'] = sort_str(opts[:sort]) if opts[:sort]
        end
        JSON.parse(res)
      end

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
