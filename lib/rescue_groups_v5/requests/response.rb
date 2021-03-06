# frozen_string_literal: true

require "json"

module RescueGroupsV5
  module Requests
    class Response
      def initialize(json, nest_data = nil)
        @json = json
        @nest_data = nest_data || Config.read(:nest_data)
      end

      def run
        data = JSON.parse(@json)
        if @nest_data && !data["included"]&.empty?
          data["data"].each do |data_hash|
            data_hash["relationships"].each do |_obj_name, rel_hash|
              rel_hash["data"].each do |rel_data_hash|
                rel_data_hash.merge!(get_included_data(data["included"], rel_data_hash))
              end
            end
          end
        end
        data
      end

      private

      def get_included_data(included_data, my_hash)
        my_data = included_data.select do |included_hash|
          included_hash["type"] == my_hash.fetch("type") &&
            included_hash["id"] == my_hash.fetch("id")
        end.first
        my_data ? my_data["attributes"] : {}
      end
    end
  end
end
