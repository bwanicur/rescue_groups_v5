require_relative '../client'
require_relative '../helpers/case_converter'

module RescueGroupsV5
  module Requests
    class Animal
      PATH = '/animals'

      def initialize(opts = {})
        @client = RescueGroupsV5::Client.new
      end

      # TODO: YARD DOC HERE
      def search(opts = {})
        @client.post_request("/#{PATH}/search", opts)
      end

      # TODO: YARD DOC HERE
      def find(id)
        @client.get_request(PATH, opts)
      end
    end
  end
end
