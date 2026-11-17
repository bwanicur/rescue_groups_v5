# frozen_string_literal: true

require "spec_helper"

RSpec.describe RescueGroupsV5::Requests::Animal do
  describe "#search" do
    it "searches the available view by default" do
      stub = stub_request(:post, "https://api.rescuegroups.org/v5/public/animals/search/available")

      described_class.new("test-key").search

      expect(stub).to have_been_requested
    end

    it "searches the given views" do
      stub = stub_request(:post, "https://api.rescuegroups.org/v5/public/animals/search/available/dogs")

      described_class.new("test-key").search(views: %i[available dogs])

      expect(stub).to have_been_requested
    end

    it "searches without a view when views is empty" do
      stub = stub_request(:post, "https://api.rescuegroups.org/v5/public/animals/search")

      described_class.new("test-key").search(views: [])

      expect(stub).to have_been_requested
    end

    it "searches without a view when views is nil" do
      stub = stub_request(:post, "https://api.rescuegroups.org/v5/public/animals/search")

      described_class.new("test-key").search(views: nil)

      expect(stub).to have_been_requested
    end

    it "raises InvalidViewError for an unknown view without making a request" do
      expect { described_class.new("test-key").search(views: [:dog]) }
        .to raise_error(RescueGroupsV5::InvalidViewError, /Invalid view\(s\): dog/)
      expect(a_request(:any, /rescuegroups/)).not_to have_been_made
    end

    it "rejects documented views that are broken in the API" do
      %i[attending haspic guineapigs hermitcrabs prairiedogs sugargliders].each do |view|
        expect { described_class.new("test-key").search(views: [view]) }
          .to raise_error(RescueGroupsV5::InvalidViewError)
      end
    end
  end

  describe "#find" do
    it "gets a single animal" do
      stub = stub_request(:get, "https://api.rescuegroups.org/v5/public/animals/100000")
             .with(query: { "fields" => { "animals" => "name" } })

      described_class.new("test-key").find(100_000, fields: { animals: [:name] })

      expect(stub).to have_been_requested
    end
  end

  describe "#list" do
    it "lists animals" do
      stub = stub_request(:get, "https://api.rescuegroups.org/v5/public/animals").with(query: { "limit" => "5" })

      described_class.new("test-key").list(limit: 5)

      expect(stub).to have_been_requested
    end
  end

  describe "#get_breeds" do
    it "lists animal breeds" do
      stub = stub_request(:get, "https://api.rescuegroups.org/v5/public/animals/breeds")

      described_class.new("test-key").get_breeds

      expect(stub).to have_been_requested
    end
  end
end
