require 'spec_helper'
require_relative '../../lib/rescue_groups_v5/services/filter_builder'

RSpec.describe RescueGroupsV5::Services::FilterBuilder do
  describe 'self.transform_filters' do
    let(:raw_filters_data) do
      {
        age: {
          operation: :less_than,
          value: 10
        },
        color: 'brown',
        breed: {
          operation: :contains,
          value: 'pitbull'
        }
      }
    end
    it "should transform filter data into the appropriate hash of data that RG API V5 requires" do
      res = described_class.transform_filters(raw_filters_data)
      expect(res[0][:fieldName]).to eq(:age)
      expect(res[0][:operation]).to eq(:lessthan)
      expect(res[0][:criterion]).to eq(10)
      expect(res[1][:fieldName]).to eq(:color)
      expect(res[1][:operation]).to eq(:equals)
      expect(res[1][:criterion]).to eq('brown')
      expect(res[2][:fieldName]).to eq(:breed)
      expect(res[2][:operation]).to eq(:contains)
      expect(res[2][:criterion]).to eq('pitbull')
    end
  end
end
