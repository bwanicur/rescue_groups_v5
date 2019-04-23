require 'spec_helper'
require_relative '../lib/rescue_groups_v5/client'

# Integration Tests
RSpec.describe RescueGroupsV5::Client do
  let(:api_key) { ENV['RESCUE_GROUPS_V5_API_KEY'] || 'shouldnotmatter' }
  let(:client) { described_class.new(api_key) }
  
  describe "#search_animals" do
    let(:filter_opts) do
      [
        {
          fieldName: 'animals.breedPrimary',
          operation: 'contains',
          criteria: 'Staffordshire'
        },
        {
          operation: 'greaterThan',
          fieldName: 'animals.birthDate',
          criteria: '01-01-2012'
        }
      ]
    end
    let(:opts) do
      {
        filters: filter_opts,
        fields: {
          animals: [ :name, :breedPrimary ],
          orgs: [ :name, :city ]
        },
        included: [ :orgs ],
        zipcode: '92107',
        radius_in_miles: 15
      }
    end
    # it "should return a collection of animals" do
    #   VCR.use_cassette('search_animals') do
    #
    #   end
    # end
  end
end
