require 'spec_helper'
require_relative '../../lib/rescue_groups_v5/requests/request'

RSpec.describe RescueGroupsV5::Requests::Request do
  # Cannot get this to work :/  Matching on exact URL
  # let(:animals_url_regex) { /\/v5\/public\/animals.+/ }
  let(:test_get_url) do
    "/v5/public/animals?fields=fields%5Banimals%5D%3Dname%2CageGroup%2CbreedPrimary%26fields%5Borgs%5D%3Dname%2Ccity%26fields%5Bfosters%5D%3Demail&includes=animals%2Corgs%2Cfosters&limit=10&sort=animals.ageGroup-%2Corgs.name%2B&start=20"
  end

  let(:test_post_url) { "/v5/public/animals/search" }

  let(:empty_response) do
    {
      data: [],
      included: []
    }.to_json
  end

  let(:conn_stub) do
    Faraday.new do |builder|
      builder.adapter :test do |stub|
        stub.get(test_get_url) { |env| [ 200, {}, empty_response ] }
        stub.post(test_post_url) { |env| [ 200, {}, empty_response ] }
      end
    end
  end
  let(:api_key) { 'shouldnotmatter' }
  let(:url) { described_class::URL }

  describe '#get' do
    it 'should send the connection the proper params' do
      opts = {
        includes: [ :animals, :orgs, :fosters ],
        fields: {
          animals: [ :name, :ageGroup, :breedPrimary ],
          orgs: [ :name, :city ],
          fosters: [ :email ]
        },
        sort: [
          {
            object: :animals,
            sort_value: 'ageGroup',
            direction: :descending
          },
          {
            object: :orgs,
            sort_value: 'name'
          }
        ],
        limit: 10,
        start: 20,
      }
      stub_client = described_class.new(api_key, conn_stub)
      stub_client.get('/animals', opts)
      # yikes... this is difficult to test
      stub_req_obj = conn_stub.app.stubs.instance_variable_get(:@consumed)[:get].first
      expect(stub_req_obj.path).to eq('/v5/public/animals')
      expect(stub_req_obj.params['fields']).to eq("fields[animals]=name,ageGroup,breedPrimary&fields[orgs]=name,city&fields[fosters]=email")
      expect(stub_req_obj.params['includes']).to eq("animals,orgs,fosters")
      expect(stub_req_obj.params['sort']).to eq("animals.ageGroup-,orgs.name+")
      expect(stub_req_obj.params['start']).to eq("20")
      expect(stub_req_obj.params['limit']).to eq("10")
    end
  end

  # TODO: currently cannot inspect the body or headers of the test struct obj
  # describe '#post' do
  #   it 'should send the connection the proper post body' do
  #     opts = {
  #       filters: [
  #         {
  #           object: :animals,
  #           field_name: 'name',
  #           operation: :contains,
  #           value: 'roxy'
  #         },
  #         {
  #           object: :orgs,
  #           field_name: 'name',
  #           operation: :contains,
  #           value: 'rescue'
  #         }
  #       ]
  #     }
  #     stub_client = described_class.new(api_key, conn_stub)
  #     stub_client.post('/animals/search', opts)
  #     stub_req_obj = conn_stub.app.stubs.instance_variable_get(:@consumed)[:post].first
  #     expect(stub_req_obj.body).to_not be_nil
  #   end
  # end

end
