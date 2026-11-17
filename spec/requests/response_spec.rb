# frozen_string_literal: true

require "spec_helper"
require_relative "../../lib/rescue_groups_v5/requests/response"
require_relative "../support/parsed_response"

RSpec.describe RescueGroupsV5::Requests::Response do
  include ParsedResponse

  describe "run" do
    it "will parse JSON without any included data" do
      data = parsed_response.merge("included" => []).to_json
      res = described_class.new(data).run
      expect(res).to be_instance_of(Hash)
      expect(res["data"].size).to eq(2)
      expect(res["included"]).to eq([])
    end

    context "ONE INCLUDE" do
      it "will parse JSON and nest any included data" do
        res = described_class.new(parsed_response.to_json, true).run
        expect(res["data"].size).to eq(2)
        first = res["data"].first
        expect(first["relationships"]["orgs"]["data"].first["name"]).to eq("Animal Relief Fund")
        expect(first["relationships"]["orgs"]["data"].first["city"]).to eq("Hollywood")
        second = res["data"].last
        expect(second["relationships"]["orgs"]["data"].first["name"]).to eq("Quincy Animal Shelter")
        expect(second["relationships"]["orgs"]["data"].first["city"]).to eq("Quincy")
      end
    end

    it "does not nest included data when nest_data is not set" do
      res = described_class.new(parsed_response.to_json).run
      expect(res["data"].first["relationships"]["orgs"]["data"].first).to eq("type" => "orgs", "id" => "16")
    end

    it "keeps the included section when nesting" do
      res = described_class.new(parsed_response.to_json, true).run
      expect(res["included"].map { |hash| hash["id"] }).to eq(%w[16 2608])
    end

    it "nests nothing for a relationship with no matching included object" do
      data = parsed_response
      data["included"] = [data["included"].first]
      res = described_class.new(data.to_json, true).run
      expect(res["data"].last["relationships"]["orgs"]["data"].first).to eq("type" => "orgs", "id" => "2608")
    end

    it "handles a response with no included key when nesting" do
      data = parsed_response
      data.delete("included")
      res = described_class.new(data.to_json, true).run
      expect(res["data"].size).to eq(2)
    end

    it "handles data without relationships when nesting" do
      data = parsed_response
      data["data"].first.delete("relationships")
      res = described_class.new(data.to_json, true).run
      expect(res["data"].first).not_to have_key("relationships")
      expect(res["data"].last["relationships"]["orgs"]["data"].first["name"]).to eq("Quincy Animal Shelter")
    end

    it "returns API errors unchanged" do
      json = { "errors" => [{ "status" => 400, "title" => "Invalid Sort" }] }.to_json
      res = described_class.new(json, true).run
      expect(res).to eq("errors" => [{ "status" => 400, "title" => "Invalid Sort" }])
    end
  end
end
