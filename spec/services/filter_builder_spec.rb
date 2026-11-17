# frozen_string_literal: true

require "spec_helper"
require_relative "../../lib/rescue_groups_v5/services/filter_builder"

RSpec.describe RescueGroupsV5::Services::FilterBuilder do
  describe "self.run" do
    it "should transform filter data into the appropriate hash of data that RG API V5 requires" do
      raw_filters_data = [
        { object: :animals, field_name: :age, operation: "less_than", criteria: 10 },
        { object: :animals, field_name: :color, criteria: "brown" },
        { object: :animals, field_name: :breed, operation: :contains, criteria: "Pitbull" }
      ]

      res = described_class.run(raw_filters_data)

      expect(res).to eq(
        [
          { fieldName: "animals.age", operation: "lessthan", criteria: 10 },
          { fieldName: "animals.color", operation: "equal", criteria: "brown" },
          { fieldName: "animals.breed", operation: "contains", criteria: "Pitbull" }
        ]
      )
    end

    it "defaults the operation to equal" do
      res = described_class.run([{ object: :orgs, field_name: :type, criteria: "Shelter" }])
      expect(res.first[:operation]).to eq("equal")
    end

    it "passes array criteria through unchanged" do
      res = described_class.run([{ object: :animals, field_name: :sizeGroup, criteria: %w[Small Medium] }])
      expect(res.first[:criteria]).to eq(%w[Small Medium])
    end

    it "translates every supported operation to the API operation name" do
      expected = {
        equals: "equal",
        not_equal: "notequal",
        less_than: "lessthan",
        less_than_or_equal: "lessthanorequal",
        greater_than: "greaterthan",
        greater_than_or_equal: "greaterthanorequal",
        contains: "contains",
        not_contain: "notcontain",
        blank: "blank",
        not_blank: "notblank"
      }

      expected.each do |operation, api_operation|
        res = described_class.run([{ object: :animals, field_name: :name, operation: operation, criteria: "x" }])
        expect(res.first[:operation]).to eq(api_operation)
      end
    end
  end
end
