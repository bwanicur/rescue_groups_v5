require 'spec_helper'
require_relative '../../lib/rescue_groups_v5/requests/response'
require_relative '../support/parsed_response'

RSpec.describe RescueGroupsV5::Requests::Response do
  include ParsedResponse

  describe 'run' do
    it 'will parse JSON without any included data' do
      data = parsed_response.merge('included' => []).to_json
      res = described_class.new(data).run
      expect(res).to be_instance_of(Hash)
      expect(res['data'].size).to eq(2)
      expect(res['included']).to eq([])
    end

    context 'ONE INCLUDE' do
      it 'will parse JSON and nest any included data' do
        res = described_class.new(parsed_response.to_json).run
        expect(res['data'].size).to eq(2)
        first = res['data'].first
        expect(first['relationships']['orgs']['data'].first['name']).to_not be_nil
        expect(first['relationships']['orgs']['data'].first['city']).to_not be_nil
        second = res['data'].last
        expect(second['relationships']['orgs']['data'].first['name']).to_not be_nil
        expect(second['relationships']['orgs']['data'].first['city']).to_not be_nil
      end
    end
  end
end
