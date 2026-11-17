# frozen_string_literal: true

require "spec_helper"

RSpec.describe RescueGroupsV5::Requests::Request do
  describe "#get" do
    it "sends the API key and the JSON:API content type" do
      stub = stub_request(:get, "https://api.rescuegroups.org/v5/public/animals/1")
             .with(headers: { "Authorization" => "test-key", "Content-Type" => "application/vnd.api+json" })

      described_class.new("test-key").get("/animals/1")

      expect(stub).to have_been_requested
    end

    it "sends fields as fields[object] query params" do
      stub = stub_request(:get, "https://api.rescuegroups.org/v5/public/animals/1")
             .with(query: { "fields" => { "animals" => "name,breedPrimary", "orgs" => "name" } })

      described_class.new("test-key").get("/animals/1", fields: { animals: %i[name breedPrimary], orgs: [:name] })

      expect(stub).to have_been_requested
    end

    it "sends include, sort, page and limit query params" do
      stub = stub_request(:get, "https://api.rescuegroups.org/v5/public/animals")
             .with(query: { "include" => "orgs,breeds", "sort" => "-animals.name", "page" => "2", "limit" => "10" })

      described_class.new("test-key").get(
        "/animals",
        include: %i[orgs breeds],
        sort: [{ object: :animals, sort_value: :name, direction: :descending }],
        page: 2,
        limit: 10
      )

      expect(stub).to have_been_requested
    end

    it "sends an empty include param for an empty include array" do
      stub = stub_request(:get, "https://api.rescuegroups.org/v5/public/animals").with(query: { "include" => "" })

      described_class.new("test-key").get("/animals", include: [])

      expect(stub).to have_been_requested
    end

    it "does not send a body, filters or radius" do
      stub = stub_request(:get, "https://api.rescuegroups.org/v5/public/animals")
             .with { |request| request.body.to_s.empty? }

      described_class.new("test-key").get(
        "/animals",
        filters: [{ object: :animals, field_name: :name, criteria: "Rex" }],
        postalcode: "92107"
      )

      expect(stub).to have_been_requested
    end
  end

  describe "#post" do
    it "sends an empty data object when there are no filters or radius" do
      stub = stub_request(:post, "https://api.rescuegroups.org/v5/public/animals/search")
             .with(body: { "data" => {} }.to_json)

      described_class.new("test-key").post("/animals/search")

      expect(stub).to have_been_requested
    end

    it "sends filters in the body" do
      body = {
        "data" => {
          "filters" => [{ "fieldName" => "animals.breedPrimary", "operation" => "contains", "criteria" => "Lab" }]
        }
      }
      stub = stub_request(:post, "https://api.rescuegroups.org/v5/public/animals/search")
             .with(body: body.to_json)

      described_class.new("test-key").post(
        "/animals/search",
        filters: [{ object: :animals, field_name: :breedPrimary, operation: :contains, criteria: "Lab" }]
      )

      expect(stub).to have_been_requested
    end

    it "sends a postalcode radius in the body" do
      body = { "data" => { "filterRadius" => { "postalcode" => "92107", "miles" => 25 } } }
      stub = stub_request(:post, "https://api.rescuegroups.org/v5/public/animals/search")
             .with(body: body.to_json)

      described_class.new("test-key").post("/animals/search", postalcode: "92107", miles: 25)

      expect(stub).to have_been_requested
    end

    it "sends a lat/lon radius in the body" do
      body = { "data" => { "filterRadius" => { "lat" => 32.7, "lon" => -117.2, "kilometers" => 15 } } }
      stub = stub_request(:post, "https://api.rescuegroups.org/v5/public/animals/search")
             .with(body: body.to_json)

      described_class.new("test-key").post("/animals/search", lat: 32.7, lon: -117.2, kilometers: 15)

      expect(stub).to have_been_requested
    end

    it "does not send a radius with only lat or only lon" do
      stub = stub_request(:post, "https://api.rescuegroups.org/v5/public/animals/search")
             .with(body: { "data" => {} }.to_json)

      described_class.new("test-key").post("/animals/search", lat: 32.7)

      expect(stub).to have_been_requested
    end

    it "sends query params alongside the body" do
      stub = stub_request(:post, "https://api.rescuegroups.org/v5/public/orgs/search")
             .with(query: { "fields" => { "orgs" => "name" }, "limit" => "5" }, body: { "data" => {} }.to_json)

      described_class.new("test-key").post("/orgs/search", fields: { orgs: [:name] }, limit: 5)

      expect(stub).to have_been_requested
    end
  end
end
