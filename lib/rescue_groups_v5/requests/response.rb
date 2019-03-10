require 'json'

module RescueGroupsV5
  module Requests
    class Response

      def initialize(json)
        @json = json
      end

      def run
        data = JSON.parse(@json)
        if !data['included'].empty?
          data['data'].each do |data_hash|
            data_hash['relationships'].each do |obj_name, rel_hash|
              rel_hash['data'].each do |rel_data_hash|
                my_included_data = data['included'].select do |included_hash|
                  included_hash['type'] == rel_data_hash.fetch('type') &&
                  included_hash['id'] == rel_data_hash.fetch('id')
                end.first
                if my_included_data['attributes']
                  rel_data_hash.merge!(my_included_data['attributes'])
                end
              end
            end
          end
        end
        data
      end

    end
  end
end
