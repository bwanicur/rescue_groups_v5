# frozen_string_literal: true

require "spec_helper"
require_relative "../../lib/rescue_groups_v5/services/radius_filter_builder"

RSpec.describe RescueGroupsV5::Services::RadiusFilterBuilder do
  describe "self.run" do
    let(:postalcode_data) do
      { postalcode: 92107 }
    end
    let(:coordinates_data) do
      { lat: 32.7174, lon: -117.1628 }
    end
    it "builds a JSON object with using postalcode and miles"
    it "builds a JSON object with using postalcode and kilometeres"
    it "builds a JSON object with using lat/lon and miles"
    it "builds a JSON object with using lat/long and kilometers"
  end
end
