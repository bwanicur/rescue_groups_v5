require 'spec_helper'
require_relative '../lib/rescue_groups_v5/client'

# Integration Tests
RSpec.describe RescueGroupsV5::Client do
  let(:api_key) { ENV['RESCUE_GROUPS_V5_API_KEY'] || 'shouldnotmatter' }
  let(:client) { described_class.new(api_key) }

  describe '#search_animals' do
    let(:filter_opts) do
      [
        {
          object: 'animals',
          field_name: 'breedPrimary',
          operation: 'contains',
          criteria: 'Staffordshire'
        },
        {
          object: 'statuses',
          field_name: 'name',
          operation: :equals,
          criteria: 'Available'
        }
      ]
    end
    let(:limit) { 30 }
    let(:opts) do
      {
        filters: filter_opts,
        fields: {
          animals: [ :name, :breedPrimary ],
          orgs: [ :name, :city, :state ]
        },
        include: [ :orgs ],
        postalcode: '92107',
        radius_in_miles: 100,
        limit: limit
      }
    end
    let(:subject) do
      VCR.use_cassette('search-animals') { client.search_animals(opts) }
    end

    it "returns a collection of animals centered (loosely :) )around a postalcode" do
      expect(subject['included']).to be
      # TODO: The filterRadius is not strict about results from postalcode / radius search
      #       This test is not conclusive
      expect(
        subject['included']
          .map{ |org| org['attributes']['state'] }
          .uniq
          .first
      ).to eq('CA')
    end

    it 'returns a limit of animals' do
      expect(subject['data'].count).to eq(limit)
    end

    it 'returns only the fields that are requested' do
      expect(subject['data'].first['attributes'].keys.sort).to eq(
        %w(breedPrimary distance name)
      )
    end
  end

  describe '#get_animal' do
    let(:id) { 11103925 }
    let(:opts) do
      {
        fields: {
          animals: [ :name, :breedPrimary, :ageGroup ]
        }
      }
    end
    let(:subject) do
      VCR.use_cassette('get-animal') { client.get_animal(id, opts) }
    end
    it 'returns data for a single animal by ID' do
      expect(subject['data'][0]['id']).to eq(id.to_s)
    end
    it 'returns only the fields that are requested' do
      expect(subject['data'][0]['attributes'].keys.sort).to eq(
        %w(ageGroup breedPrimary name)
      )
    end
  end

  describe '#get_animal_breeds' do
    let(:limit) { 100 }
    it 'returns the list of animal breeds' do
      VCR.use_cassette('get-animal-breeds') do
        res = client.get_animal_breeds(limit: limit)
        expect(res['data'].size).to eq(limit)
        expect(res['data'].first['attributes'].keys).to eq(['name'])
      end
    end
  end

  describe '#search_orgs' do
    let(:limit) { 5 }
    let(:opts) do
      {
        fields: {
          orgs: [ :name, :city, :state ]
        },
        postalcode: '92107',
        radius_in_miles: 100,
        limit: limit
      }
    end
    
    let(:subject) do
      VCR.use_cassette('search-orgs-radius-filter') do
        client.search_orgs(opts)
      end
    end

    it 'returns orgs within a radius of a postalcode' do
      distances = subject['data'].map do |hash| 
        hash['attributes']['distance']
      end
      expect(distances.select{ |d| d > 100 }.size).to eq(0)
    end

    it 'returns a limited number of results' do
      expect(subject['data'].size).to eq(limit)
    end

    it 'returns orgs filtered by attributes' do
      res = nil
      filter_opts = [{
        object: 'orgs',
        field_name: 'city',
        operation: 'equals',
        criteria: 'Los Angeles'
      }]
      VCR.use_cassette('search-org-filters') do
        res = client.search_orgs({ filters: filter_opts, limit: limit })
      end
      city_names = res['data'].map{ |hash| hash['attributes']['city'] }
      uniq_city_names = city_names.map { |cn| cn.downcase }.uniq
      expect(uniq_city_names.size).to eq(1)
      expect(uniq_city_names.first).to eq('los angeles')
    end
  end

  describe '#get_org_animals' do
    let(:org_id) { 105 }
    let(:limit) { 20 }
    let(:subject) do
      VCR.use_cassette('list-org-animals') do
        client.get_org_animals(org_id, { limit: limit })
      end
    end

    it 'returns a list of animals belonging to a Org' do
      expect(subject['data']).to be_a(Array)
      expect(subject['data'].size).to eq(limit)
    end
  end

  describe '#search_org_animals' do
    let(:org_id) { 105 }
    let(:filter_opts) do
      [
        {
          object: 'animals',
          field_name: 'breedPrimary',
          operation: :equals,
          criteria: 'Shepherd'
        },
        {
          object: 'animals',
          field_name: 'ageGroup',
          operation: :equals,
          criteria: 'Adult'
        }
      ]
    end
    let(:opts) do
      {
        filters: filter_opts,
        fields: {
          animals: [ :breedPrimary, :ageGroup, :name ]
        }
      }
    end
    let(:subject) do
      VCR.use_cassette('search-org-animals') do
        client.search_org_animals(org_id, opts)
      end
    end

    it 'returns animals matching the search criteria' do
      skip 'Only works in the TEST API endpoint currently'
    end
  end
end
