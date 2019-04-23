require 'faraday'
require_relative './response'
require_relative '../services/filter_builder'
require_relative '../services/sort_builder'
require_relative '../services/fields_builder'

module RescueGroupsV5
  module Requests
    class Request
      URL = 'https://api.rescuegroups.org/v5/public'.freeze

      def initialize(api_key, connection = nil)
        @conn = connection || Faraday.new
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
        res = @conn.send(verb, "#{URL}#{path}") do |req|
          req.headers['Content-Type'] = 'application/json'
          req.headers['Authorization'] = @api_key
          req.params['includes'] = includes_str(opts[:includes]) if opts[:includes]
          req.params['sort'] = sort_str(opts[:sort]) if opts[:sort]
          req.params['start'] = opts[:start] if opts[:start]
          req.params['limit'] = opts[:limit] if opts[:limit]
          req.params['fields'] = fields_str(opts[:fields]) if opts[:fields]
          if verb == :post
            body_data = { 'data' => {} }
            if opts[:filters]
              body_data['data']['filters'] = filters_data(opts[:filters])
            end
            if opts[:filter_radius]
              body_data['data']['filterRadius'] = filter_radius_data(opts[:filter_radius])
            end
            req.body = body_data.to_json
          end
        end
        Response.new(res.body, opts[:no_nest_data]).run
      end

      def includes_str(includes = [])
        includes.map(&:to_s).join(',')
      end

      def sort_str(sort_data = {})
        RescueGroupsV5::Services::SortBuilder.run(sort_data)
      end

      def fields_str(fields_data = {})
        RescueGroupsV5::Services::FieldsBuilder.run(fields_data)
      end

      def filter_radius_data(data = {})
        {
          zipcode: data[:zipcode],
          miles: data[:radius_in_miles]
        }
      end

      def filters_data(filter_data = {})
        RescueGroupsV5::Services::FilterBuilder.run(filter_data)
      end
    end
  end
end
