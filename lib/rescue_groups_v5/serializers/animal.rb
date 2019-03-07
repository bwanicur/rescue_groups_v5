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
        JSON.parse(@json).inject({}) do |mem, key_val_array|
          key, value = key_val_array
          if RescueGroupsV5::Fields::Animal::FIELDS.include?(key)
            mem[convert_to_snake_case(key).to_sym] = value
          end
        end
      end
    end
  end
end
