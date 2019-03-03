require 'json'
require_relative '../fields/animal'
require_relative '../helpers/case_converter'

module RescueGroupsV5
  module Serializers
    class Animal
      include CaseConverter

      def initialize(json)
        @json = json
      end

      def data
        # TODO: depends on the format of the JSON we get from RG... might have to wait
        res = {}
        JSON.parse(@json).each do |key, value|
          if RescueGroupsV5::Fields::Animal::FIELDS.include?(key)
            res[convert_to_snake_case(key)] = value
          end
        end
        res
      end
    end
  end
end
