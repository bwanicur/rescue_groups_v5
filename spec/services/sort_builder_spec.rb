# frozen_string_literal: true

require "spec_helper"
require_relative "../../lib/rescue_groups_v5/services/sort_builder"

RSpec.describe RescueGroupsV5::Services::SortBuilder do
  describe "self.run" do
    it "should create a properly formatted sort string" do
      data = [
        { object: :animals, sort_value: "ageGroup", direction: :ascending },
        { object: :orgs, sort_value: "name", direction: :ascending },
        { object: :fosters, sort_value: "email", direction: :descending }
      ]

      res = described_class.run(data)

      expect(res).to eq("animals.ageGroup,orgs.name,-fosters.email")
    end

    it "should default to ascending as direction" do
      data = [
        { object: :animals, sort_value: "name" },
        { object: :orgs, sort_value: "name" }
      ]

      res = described_class.run(data)

      expect(res).to eq("animals.name,orgs.name")
    end

    it "prefixes descending sorts with a dash" do
      res = described_class.run([{ object: :animals, sort_value: :distance, direction: :descending }])
      expect(res).to eq("-animals.distance")
    end
  end
end
