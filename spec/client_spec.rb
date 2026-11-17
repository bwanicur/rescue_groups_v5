# frozen_string_literal: true

require "spec_helper"

# Integration tests against recorded RescueGroups API responses (spec/vcr).
# To re-record, delete a cassette and run with RESCUE_GROUPS_V5_API_KEY set.
RSpec.describe RescueGroupsV5::Client do
  let(:client) { described_class.new(ENV.fetch("RESCUE_GROUPS_V5_API_KEY", "test-key")) }

  def statuses(response)
    response["included"].select { |hash| hash["type"] == "statuses" }.map { |hash| hash["attributes"]["name"] }.uniq
  end

  describe "#search_animals" do
    it "returns only available animals by default" do
      res = VCR.use_cassette("search-animals-default") do
        client.search_animals(limit: 10, include: [:statuses], fields: { animals: [:name], statuses: [:name] })
      end

      expect(res["data"].size).to eq(10)
      expect(statuses(res)).to eq(["Available"])
    end

    it "returns animals of any status when views is empty" do
      available = VCR.use_cassette("search-animals-count-available") { client.search_animals(limit: 0) }
      all = VCR.use_cassette("search-animals-count-unscoped") { client.search_animals(limit: 0, views: []) }

      expect(all["meta"]["count"]).to be > available["meta"]["count"]
    end

    it "returns animals matching the given views" do
      res = VCR.use_cassette("search-animals-views") do
        client.search_animals(
          views: %i[available dogs],
          limit: 10,
          include: [:species],
          fields: { animals: [:name], species: [:singular] }
        )
      end

      species = res["included"].select { |hash| hash["type"] == "species" }.map { |hash| hash["attributes"]["singular"] }
      expect(species.uniq).to eq(["Dog"])
    end

    it "returns animals within a radius of a postalcode" do
      res = VCR.use_cassette("search-animals-postalcode") do
        client.search_animals(postalcode: "92107", miles: 25, limit: 25, include: [], fields: { animals: %i[name distance] })
      end

      distances = res["data"].map { |hash| hash["attributes"]["distance"] }
      expect(distances).not_to be_empty
      expect(distances).to all(be <= 25)
    end

    it "returns animals within a radius of a lat/lon point" do
      res = VCR.use_cassette("search-animals-lat-lon") do
        client.search_animals(lat: 32.7174, lon: -117.1628, kilometers: 15, limit: 25, include: [], fields: { animals: [:distance] })
      end

      distances = res["data"].map { |hash| hash["attributes"]["distance"] }
      expect(distances).not_to be_empty
      expect(distances).to all(be <= 15)
    end

    it "returns animals matching the filters" do
      res = VCR.use_cassette("search-animals-filters") do
        client.search_animals(
          filters: [
            { object: :animals, field_name: :breedPrimary, operation: :contains, criteria: "Labrador" },
            { object: :animals, field_name: :sizeGroup, criteria: %w[Medium Large] }
          ],
          limit: 25,
          include: [],
          fields: { animals: %i[breedPrimary sizeGroup] }
        )
      end

      attributes = res["data"].map { |hash| hash["attributes"] }
      expect(attributes).not_to be_empty
      expect(attributes.map { |hash| hash["breedPrimary"] }).to all(include("Labrador"))
      expect(attributes.map { |hash| hash["sizeGroup"] }).to all(eq("Medium").or(eq("Large")))
    end

    it "returns animals sorted descending" do
      res = VCR.use_cassette("search-animals-sort") do
        client.search_animals(
          sort: [{ object: :animals, sort_value: :id, direction: :descending }],
          limit: 10,
          include: [],
          fields: { animals: [:name] }
        )
      end

      ids = res["data"].map { |hash| hash["id"].to_i }
      expect(ids).to eq(ids.sort.reverse)
    end

    it "returns the requested page" do
      page1 = VCR.use_cassette("search-animals-page-1") do
        client.search_animals(page: 1, limit: 5, include: [], fields: { animals: [:name] })
      end
      page2 = VCR.use_cassette("search-animals-page-2") do
        client.search_animals(page: 2, limit: 5, include: [], fields: { animals: [:name] })
      end

      expect(page2["meta"]["pageReturned"]).to eq(2)
      expect(page1["data"].map { |hash| hash["id"] } & page2["data"].map { |hash| hash["id"] }).to be_empty
    end

    it "returns only the fields that are requested" do
      res = VCR.use_cassette("search-animals-fields") do
        client.search_animals(limit: 5, include: [:orgs], fields: { animals: %i[name sex], orgs: %i[name city] })
      end

      expect(res["data"].flat_map { |hash| hash["attributes"].keys }.uniq - %w[name sex]).to be_empty
      orgs = res["included"].select { |hash| hash["type"] == "orgs" }
      expect(orgs.flat_map { |hash| hash["attributes"].keys }.uniq.sort).to eq(%w[city name])
    end

    it "returns no related objects when include is empty" do
      res = VCR.use_cassette("search-animals-no-include") do
        client.search_animals(limit: 5, include: [], fields: { animals: [:name] })
      end

      expect(res["data"].size).to eq(5)
      expect(res).not_to have_key("included")
    end

    it "returns API errors under the errors key" do
      res = VCR.use_cassette("search-animals-invalid-limit") { client.search_animals(limit: 251) }

      expect(res["errors"].first["status"]).to eq(400)
    end

    it "raises InvalidViewError for an unknown view" do
      expect { client.search_animals(views: [:dog]) }.to raise_error(RescueGroupsV5::InvalidViewError)
    end
  end

  describe "#get_animal" do
    it "returns data for a single animal by ID" do
      res = VCR.use_cassette("get-animal") do
        client.get_animal(100_000, include: [], fields: { animals: %i[name breedPrimary ageGroup] })
      end

      expect(res["data"].first["id"]).to eq("100000")
      expect(res["data"].first["attributes"].keys.sort).to eq(%w[ageGroup breedPrimary name])
    end
  end

  describe "#get_animal_breeds" do
    it "returns the list of animal breeds" do
      res = VCR.use_cassette("get-animal-breeds") { client.get_animal_breeds(limit: 10, include: []) }

      expect(res["data"].size).to eq(10)
      expect(res["data"].map { |hash| hash["type"] }.uniq).to eq(["breeds"])
      expect(res["data"].first["attributes"].keys).to eq(["name"])
    end
  end

  describe "#search_orgs" do
    it "returns orgs within a radius of a postalcode" do
      res = VCR.use_cassette("search-orgs-postalcode") do
        client.search_orgs(postalcode: "92107", miles: 50, limit: 5, fields: { orgs: %i[name city distance] })
      end

      distances = res["data"].map { |hash| hash["attributes"]["distance"] }
      expect(distances.size).to eq(5)
      expect(distances).to all(be <= 50)
    end

    it "returns orgs matching the filters" do
      res = VCR.use_cassette("search-orgs-filters") do
        client.search_orgs(
          filters: [{ object: :orgs, field_name: :type, criteria: "Shelter" }],
          limit: 10,
          fields: { orgs: %i[name type] }
        )
      end

      expect(res["data"].map { |hash| hash["attributes"]["type"] }.uniq).to eq(["Shelter"])
    end

    it "returns orgs matching the given views" do
      res = VCR.use_cassette("search-orgs-views") do
        client.search_orgs(views: [:rescue], limit: 10, fields: { orgs: %i[name type] })
      end

      expect(res["data"].map { |hash| hash["attributes"]["type"] }.uniq).to eq(["Rescue"])
    end
  end

  describe "#get_org" do
    it "returns data for a single org by ID" do
      res = VCR.use_cassette("get-org") { client.get_org(16, fields: { orgs: %i[name city] }) }

      expect(res["data"].first["id"]).to eq("16")
      expect(res["data"].first["attributes"].keys.sort).to eq(%w[city name])
    end
  end

  describe "#get_org_animals" do
    it "returns a list of animals belonging to an org" do
      res = VCR.use_cassette("list-org-animals") do
        client.get_org_animals(16, limit: 20, include: [:orgs], fields: { animals: [:name] })
      end

      expect(res["data"].size).to eq(20)
      org_ids = res["data"].map { |hash| hash["relationships"]["orgs"]["data"].first["id"] }
      expect(org_ids.uniq).to eq(["16"])
    end
  end

  describe "#search_org_animals" do
    it "returns only the org's available animals by default" do
      res = VCR.use_cassette("search-org-animals-default") do
        client.search_org_animals(
          16,
          limit: 10,
          include: %i[orgs statuses],
          fields: { animals: [:name], statuses: [:name] }
        )
      end

      expect(res["data"]).not_to be_empty
      expect(statuses(res)).to eq(["Available"])
      org_ids = res["data"].map { |hash| hash["relationships"]["orgs"]["data"].first["id"] }
      expect(org_ids.uniq).to eq(["16"])
    end

    it "returns the org's animals matching the filters" do
      res = VCR.use_cassette("search-org-animals-filters") do
        client.search_org_animals(
          16,
          views: [],
          filters: [{ object: :animals, field_name: :ageGroup, criteria: "Adult" }],
          limit: 10,
          include: [],
          fields: { animals: %i[name ageGroup] }
        )
      end

      expect(res["data"]).not_to be_empty
      expect(res["data"].map { |hash| hash["attributes"]["ageGroup"] }.uniq).to eq(["Adult"])
    end
  end

  context "with nest_data" do
    it "nests included attributes under each relationship" do
      nesting_client = described_class.new(ENV.fetch("RESCUE_GROUPS_V5_API_KEY", "test-key"), nest_data: true)

      res = VCR.use_cassette("search-animals-nest-data") do
        nesting_client.search_animals(limit: 5, include: [:orgs], fields: { animals: [:name], orgs: %i[name city] })
      end

      orgs = res["data"].map { |hash| hash["relationships"]["orgs"]["data"].first }
      expect(orgs).to all(include("name", "city"))
    end
  end
end
