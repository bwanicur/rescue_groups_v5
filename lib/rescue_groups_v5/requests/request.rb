require 'faraday'
require_relative './response'
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
          req.params['includes'] = includes_str(opts[:includes]) if opts[:includes]
          req.params['sort'] = sort_str(opts[:sort]) if opts[:sort]
          req.params['start'] = opts[:start] if opts[:start]
          req.params['limit'] = opts[:limit] if opts[:limit]
          if opts[:fields]
            opts[:fields].each do |field_name, attributes|
              req.params['fields'] = field_str(field_name, attributes)
            end
          end
        end
        Response.new(res).run
      end

      def includes_str(includes = [])
        includes.map(&:to_s).join(',')
      end

      # TODO: replace with service
      # => check to see if direction is :ascending or :descending
      # => create sort string
      def sort_str(sort_data = {})
        sort_data.inject([]) do |array, hash|
          hash.each do |field_name, direction|
            array << "#{field_name}#{direction}"
          end
        end.join(',')
      end

      def field_str(field_name, attributes)
        "fields[#{field_name}]=#{attributes.join(',')}"
      end

      # TODO: docs
      def filters_data(opts = {})
        res = {}
        if opt[:filters]
          res.merge!(
            filters: FilterBuilder.transform_filters(opts[:filters])
          )
        end
        if opts[:zipcode] && opts[:radiusInMiles]
          res.merge!(
            filterRadius: {
              zipcode: opts[:zipcode],
              miles: opts[:radius_in_miles]
            }
          )
        end
        res
      end
    end
  end
end
