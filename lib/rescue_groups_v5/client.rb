require 'faraday'
require_relative './services/filter_builder'

module RescueGroupsV5
  class Client
    PUBLIC_URL = Config.read(:public_url) || 'https://api.rescuegroups.org/v5/'

    def initalize(atts = {})
      api_key = atts[:api_key] || Config.read(:api_key) || Config.read('api_key')
      Config.set(:api_key, api_key)
    end

    def search_animals
      # RescueGroupsV5::Requests::Animal.search()
    end

    def get_animal
      # RescueGroupsV5::Requests::Animal.find()
    end

    def search_organizations
    end

    def get_organization
    end
  end
end
