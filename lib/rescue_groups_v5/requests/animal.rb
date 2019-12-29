# frozen_string_literal: true

module RescueGroupsV5
  module Requests
    class Animal
      PATH = "/animals"

      def initialize(api_key)
        @api_key = api_key
      end

      def list(opts = {})
        request.get(PATH, opts)
      end

      def search(opts = {})
        request.post("#{PATH}/search", opts)
      end

      def find(id, opts = {})
        request.get("#{PATH}/#{id}", opts)
      end

      def get_breeds(opts = {})
        request.get("#{PATH}/breeds", opts)
      end

      private

      def request
        @request ||= Request.new(@api_key)
      end
    end
  end
end
