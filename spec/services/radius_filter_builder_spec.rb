# frozen_string_literal: true

require "spec_helper"
require_relative "../../lib/rescue_groups_v5/services/radius_filter_builder"

RSpec.describe RescueGroupsV5::Services::RadiusFilterBuilder do
  describe "self.run" do
    it "builds a JSON object using postalcode and miles" do
      res = described_class.run(postalcode: "92107", miles: 25)
      expect(res).to eq("postalcode" => "92107", "miles" => 25)
    end

    it "builds a JSON object using postalcode and kilometers" do
      res = described_class.run(postalcode: "92107", kilometers: 40)
      expect(res).to eq("postalcode" => "92107", "kilometers" => 40)
    end

    it "builds a JSON object using lat/lon and miles" do
      res = described_class.run(lat: 32.7174, lon: -117.1628, miles: 25)
      expect(res).to eq("lat" => 32.7174, "lon" => -117.1628, "miles" => 25)
    end

    it "builds a JSON object using lat/lon and kilometers" do
      res = described_class.run(lat: 32.7174, lon: -117.1628, kilometers: 40)
      expect(res).to eq("lat" => 32.7174, "lon" => -117.1628, "kilometers" => 40)
    end

    it "defaults to 10 miles when no distance is given" do
      res = described_class.run(postalcode: "92107")
      expect(res).to eq("postalcode" => "92107", "miles" => 10)
    end

    it "prefers postalcode when both postalcode and lat/lon are given" do
      res = described_class.run(postalcode: "92107", lat: 32.7174, lon: -117.1628)
      expect(res).to eq("postalcode" => "92107", "miles" => 10)
    end

    it "prefers kilometers when both miles and kilometers are given" do
      res = described_class.run(postalcode: "92107", miles: 25, kilometers: 40)
      expect(res).to eq("postalcode" => "92107", "kilometers" => 40)
    end

    it "returns nil without a postalcode or both lat and lon" do
      expect(described_class.run(lat: 32.7174)).to be_nil
      expect(described_class.run(miles: 25)).to be_nil
    end
  end
end
