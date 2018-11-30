require 'spec_helper'
require_relative '../../lib/rescue_groups_v5/helpers/case_converter'

class CaseConverterTestKlass
  include RescueGroupsV5::Helpers::CaseConverter
end

RSpec.describe "RescueGroupsV5::Helpers::CaseConverter" do
  let(:converter) { CaseConverterTestKlass.new }
  describe '#convert_camel_to_snake_case' do
    it "should convert camel cased strings to snake case" do
      word1 = 'TestCasedWords'
      word2 = 'testCasedWords'
      expect(converter.convert_camel_to_snake_case(word1)).to eq('test_cased_words')
      expect(converter.convert_camel_to_snake_case(word2)).to eq('test_cased_words')
    end
  end

  describe '#convert_snake_to_camel_case' do
    it "should convert snake cased strings to camel case" do
      word1 = 'test_cased_words'
      expect(converter.convert_snake_to_camel_case(word1)).to eq('testCasedWords')
    end
  end
end
