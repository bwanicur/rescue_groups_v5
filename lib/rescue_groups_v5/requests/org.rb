# frozen_string_literal: true

module RescueGroupsV5
  module Requests
    class Org
      PATH = "/orgs"

      def initialize(api_key)
        @api_key = api_key
      end

      def get(id)
        request.get("#{PATH}/#{id}")
      end

      def list(opts = {})
        request.get(PATH, opts)
      end

      def search(opts = {})
        request.post("#{PATH}/search", opts)
      end

      def list_animals(id, opts = {})
        request.get("#{PATH}/#{id}/animals", opts)
      end

      def search_animals(id, opts = {})
        request.post("#{PATH}/#{id}/animals/search", opts)
      end

      private

      def request
        @request ||= Request.new(@api_key)
      end
    end
  end
end
