require 'json'
require_relative '../models/fields/animal_fields'
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
          res[convert_to_snake_case(key)] = value if AnimalFields::FIELDS.include?(key)
        end
        res
      end
    end
  end
end
