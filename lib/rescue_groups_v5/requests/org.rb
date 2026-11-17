# frozen_string_literal: true

module RescueGroupsV5
  module Requests
    class Org
      PATH = "/orgs"
      # "shelter" is documented but filters on orgs.type "Shelters" (actual value is "Shelter"),
      # so it always returns 0 results. Filter on orgs.type = "Shelter" instead.
      VIEWS = %w[rescue].freeze

      def initialize(api_key)
        @api_key = api_key
      end

      def find(id, opts = {})
        request.get("#{PATH}/#{id}", opts)
      end

      def list(opts = {})
        request.get(PATH, opts)
      end

      def search(opts = {})
        request.post(Services::SearchPathBuilder.run(PATH, opts[:views], VIEWS), opts)
      end

      def list_animals(id, opts = {})
        request.get("#{PATH}/#{id}/animals", opts)
      end

      def search_animals(id, opts = {})
        views = opts.fetch(:views, Animal::DEFAULT_VIEWS)
        request.post(Services::SearchPathBuilder.run("#{PATH}/#{id}/animals", views, Animal::VIEWS), opts)
      end

      private

      def request
        @request ||= Request.new(@api_key)
      end
    end
  end
end
