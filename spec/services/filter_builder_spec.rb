# frozen_string_literal: true

require "spec_helper"
require_relative "../../lib/rescue_groups_v5/services/filter_builder"

RSpec.describe RescueGroupsV5::Services::FilterBuilder do
  describe "self.run" do
    let(:raw_filters_data) do
      [
        {
          object: :animals,
          field_name: :age,
          operation: "less_than",
          criteria: 10
        },
        {
          object: :animals,
          field_name: :color,
          criteria: "brown"
        },
        {
          object: :animals,
          field_name: :breed,
          operation: :contains,
          criteria: "Pitbull"
        }
      ]
    end
    it "should transform filter data into the appropriate hash of data that RG API V5 requires" do
      res = described_class.run(raw_filters_data)
      expect(res[0][:fieldName]).to eq("animals.age")
      expect(res[0][:operation]).to eq("lessthan")
      expect(res[0][:criteria]).to eq(10)
      expect(res[1][:fieldName]).to eq("animals.color")
      expect(res[1][:operation]).to eq("equals")
      expect(res[1][:criteria]).to eq("brown")
      expect(res[2][:fieldName]).to eq("animals.breed")
      expect(res[2][:operation]).to eq("contains")
      expect(res[2][:criteria]).to eq("Pitbull")
    end
  end
end
