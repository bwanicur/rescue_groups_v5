require 'spec_helper'
require_relative '../../lib/rescue_groups_v5/services/sort_builder'

RSpec.describe RescueGroupsV5::Services::SortBuilder do

  describe 'self.run' do
    let(:data) do
      [
        {
          object: :animals,
          sort_value: 'ageGroup',
          direction: :ascending
        },
        {
          object: :orgs,
          sort_value: 'name',
          direction: :ascending
        },
        {
          object: :fosters,
          sort_value: 'email',
          direction: :descending
        }
      ]
    end

    it "should create a properly formatted sort string" do
      res = described_class.run(data)
      expect(res).to eq('animals.ageGroup+,orgs.name+,fosters.email-')
    end

    it "should default to ascending (+) as direction" do
      data = [
        {
          object: :animals,
          sort_value: 'name'
        },
        {
          object: :orgs,
          sort_value: 'name'
        }
      ]
      res = described_class.run(data)
      expect(res).to eq('animals.name+,orgs.name+')
    end
  end

end
