# frozen_string_literal: true

require "spec_helper"
require_relative "../../lib/rescue_groups_v5/services/fields_builder"

RSpec.describe RescueGroupsV5::Services::FieldsBuilder do
  describe "self.run" do
    let(:fields_data) do
      {
        animals: %i[name age breedPrimary],
        orgs: %i[name email],
        fosters: [:email]
      }
    end
    it "should build the proper fields string" do
      res = described_class.run(fields_data)
      expect(res).to eq("fields[animals]=name,age,breedPrimary&fields[orgs]=name,email&fields[fosters]=email")
    end
  end
end
