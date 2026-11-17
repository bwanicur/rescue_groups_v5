# frozen_string_literal: true

require "faraday"
require_relative "./response"
require_relative "../services/filter_builder"
require_relative "../services/sort_builder"
require_relative "../services/fields_builder"
require_relative "../services/radius_filter_builder"
require_relative "../services/search_path_builder"

module RescueGroupsV5
  module Requests
    class Request
      URL = "https://api.rescuegroups.org/v5/public"

      def initialize(api_key)
        @api_key = api_key
        @conn = Faraday.new
      end

      def get(path, opts = {})
        base_request(verb: :get, path: path, opts: opts)
      end

      def post(path, opts = {})
        base_request(verb: :post, path: path, opts: opts)
      end

      private

      def base_request(verb:, path:, opts: {})
        path += "?#{fields_str(opts[:fields])}" if opts[:fields]
        @conn.send(verb, "#{URL}#{path}") do |req|
          req.headers["Content-Type"] = "application/vnd.api+json"
          req.headers["Authorization"] = @api_key
          req.params["include"] = include_str(opts[:include]) if opts[:include]
          req.params["sort"] = sort_str(opts[:sort]) if opts[:sort]
          req.params["page"] = opts[:page] if opts[:page]
          req.params["limit"] = opts[:limit] if opts[:limit]
          if verb == :post
            body_data = { "data" => {} }
            body_data["data"]["filters"] = filters_data(opts[:filters]) if opts[:filters]
            body_data["data"]["filterRadius"] = filter_radius_data(opts) if radius_data?(opts)
            req.body = body_data.to_json
          end
        end
      end

      def include_str(includes = [])
        includes.map(&:to_s).join(",")
      end

      def sort_str(sort_data = {})
        Services::SortBuilder.run(sort_data)
      end

      def fields_str(fields_data = {})
        Services::FieldsBuilder.run(fields_data)
      end

      def filter_radius_data(data = {})
        Services::RadiusFilterBuilder.run(data)
      end

      def radius_data?(opts)
        opts[:postalcode] || (opts[:lat] && opts[:lon])
      end

      def filters_data(filter_data = {})
        Services::FilterBuilder.run(filter_data)
      end
    end
  end
end
