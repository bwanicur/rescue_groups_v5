# frozen_string_literal: true

module RescueGroupsV5
  module Requests
    class Animal
      PATH = "/animals"
      DEFAULT_VIEWS = [:available].freeze
      # From the per-endpoint view table at https://api.rescuegroups.org/v5/public/docs.
      # Documented views that are broken in the API and therefore excluded:
      # - attending: returns a 500
      # - haspic: has no effect (filter on animals.pictureCount >= 1 instead)
      # - guineapigs, hermitcrabs, prairiedogs, sugargliders: always return 0 results
      #   (filter on species.plural, e.g. "Guinea Pigs", instead)
      VIEWS = %w[
        available adopted isspecialneeds isneedingfoster urgent iscourtesylisting
        alpacas birds cats chickens chinchillas cows degus dogs donkeys ducks ferrets fish
        frogs geckos geese gerbils goats groundhogs hamsters hedgehogs horses iguanas
        lizards llama mice otters pigs ponies rabbits rats sheep skunks snakes tarantulas
        tortoises turkeys turtles
      ].freeze

      def initialize(api_key)
        @api_key = api_key
      end

      def list(opts = {})
        request.get(PATH, opts)
      end

      def search(opts = {})
        views = opts.fetch(:views, DEFAULT_VIEWS)
        request.post(Services::SearchPathBuilder.run(PATH, views, VIEWS), opts)
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
