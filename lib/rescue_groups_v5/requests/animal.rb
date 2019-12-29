module RescueGroupsV5
  module Requests
    class Animal
      PATH = '/animals'.freeze

      def initialize(api_key)
        @api_key = api_key
      end

      def list(opts = {})
        Request.new(@api_key).get(PATH, opts)
      end

      def search(opts = {})
        Request.new(@api_key).post("#{PATH}/search", opts)
      end

      def find(id, opts = {})
        Request.new(@api_key).get("#{PATH}/#{id}", opts)
      end

      def get_breeds(opts = {})
        Request.new(@api_key).get("#{PATH}/breeds", opts)
      end
    end
  end
end
