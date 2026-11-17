# frozen_string_literal: true

require "spec_helper"

RSpec.describe RescueGroupsV5::Requests::Org do
  describe "#search" do
    it "searches without a view by default" do
      stub = stub_request(:post, "https://api.rescuegroups.org/v5/public/orgs/search")

      described_class.new("test-key").search

      expect(stub).to have_been_requested
    end

    it "searches the rescue view" do
      stub = stub_request(:post, "https://api.rescuegroups.org/v5/public/orgs/search/rescue")

      described_class.new("test-key").search(views: [:rescue])

      expect(stub).to have_been_requested
    end

    it "raises InvalidViewError for the broken shelter view" do
      expect { described_class.new("test-key").search(views: [:shelter]) }
        .to raise_error(RescueGroupsV5::InvalidViewError, "Invalid view(s): shelter. Valid views: rescue")
      expect(a_request(:any, /rescuegroups/)).not_to have_been_made
    end

    it "raises InvalidViewError for animal views" do
      expect { described_class.new("test-key").search(views: [:dogs]) }
        .to raise_error(RescueGroupsV5::InvalidViewError)
    end
  end

  describe "#find" do
    it "gets a single org" do
      stub = stub_request(:get, "https://api.rescuegroups.org/v5/public/orgs/16")
             .with(query: { "fields" => { "orgs" => "name" } })

      described_class.new("test-key").find(16, fields: { orgs: [:name] })

      expect(stub).to have_been_requested
    end
  end

  describe "#list" do
    it "lists orgs" do
      stub = stub_request(:get, "https://api.rescuegroups.org/v5/public/orgs").with(query: { "limit" => "5" })

      described_class.new("test-key").list(limit: 5)

      expect(stub).to have_been_requested
    end
  end

  describe "#list_animals" do
    it "lists an org's animals" do
      stub = stub_request(:get, "https://api.rescuegroups.org/v5/public/orgs/16/animals")

      described_class.new("test-key").list_animals(16)

      expect(stub).to have_been_requested
    end
  end

  describe "#search_animals" do
    it "searches the org's available animals by default" do
      stub = stub_request(:post, "https://api.rescuegroups.org/v5/public/orgs/16/animals/search/available")

      described_class.new("test-key").search_animals(16)

      expect(stub).to have_been_requested
    end

    it "searches the org's animals with the given views" do
      stub = stub_request(:post, "https://api.rescuegroups.org/v5/public/orgs/16/animals/search/available/cats")

      described_class.new("test-key").search_animals(16, views: %i[available cats])

      expect(stub).to have_been_requested
    end

    it "searches all of the org's animals when views is empty" do
      stub = stub_request(:post, "https://api.rescuegroups.org/v5/public/orgs/16/animals/search")

      described_class.new("test-key").search_animals(16, views: [])

      expect(stub).to have_been_requested
    end

    it "raises InvalidViewError for org views" do
      expect { described_class.new("test-key").search_animals(16, views: [:rescue]) }
        .to raise_error(RescueGroupsV5::InvalidViewError)
    end
  end
end
