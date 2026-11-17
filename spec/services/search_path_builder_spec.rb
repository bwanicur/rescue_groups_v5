# frozen_string_literal: true

require "spec_helper"
require_relative "../../lib/rescue_groups_v5/services/search_path_builder"

RSpec.describe RescueGroupsV5::Services::SearchPathBuilder do
  describe "self.run" do
    it "appends each view to the search path in order" do
      res = described_class.run("/animals", %i[available dogs], %w[available dogs cats])
      expect(res).to eq("/animals/search/available/dogs")
    end

    it "accepts string views" do
      res = described_class.run("/animals", %w[cats], %w[available dogs cats])
      expect(res).to eq("/animals/search/cats")
    end

    it "returns the unscoped search path for an empty array" do
      expect(described_class.run("/animals", [], %w[available])).to eq("/animals/search")
    end

    it "returns the unscoped search path for nil" do
      expect(described_class.run("/orgs", nil, %w[rescue])).to eq("/orgs/search")
    end

    it "raises InvalidViewError naming the invalid views and the valid ones" do
      expect { described_class.run("/animals", %i[available dog bogus], %w[available dogs]) }
        .to raise_error(RescueGroupsV5::InvalidViewError, "Invalid view(s): dog, bogus. Valid views: available, dogs")
    end

    it "raises an ArgumentError subclass" do
      expect { described_class.run("/orgs", [:shelter], %w[rescue]) }.to raise_error(ArgumentError)
    end
  end
end
