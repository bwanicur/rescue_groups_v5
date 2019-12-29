module RescueGroupsV5
  module Requests
    class Org
      PATH = '/orgs'.freeze

      def initialize(api_key)
        @api_key = api_key
      end

      def get(id)
        Request.new(@api_key).get("#{PATH}/#{id}")
      end

      def list(opts = {})
        Request.new(@api_key).get(PATH, opts)
      end

      def search(opts = {})
        Request.new(@api_key).post("#{PATH}/search", opts)
      end

      def list_animals(id, opts = {})
        Request.new(@api_key).get("#{PATH}/#{id}/animals", opts)
      end

      def search_animals(id, opts = {})
        Request.new(@api_key).post("#{PATH}/#{id}/animals/search", opts)
      end
    end
  end
end
