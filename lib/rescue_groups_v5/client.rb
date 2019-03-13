module RescueGroupsV5
  class Client
    def initialize(api_key = nil)
      @api_key = api_key || Config.read(:api_key)
    end

    def search_animals
      animal_request.search(opts)
    end

    def get_animal(opts = {})
      animal_request.find(opts)
    end

    def search_organizations
    end

    def get_organization
    end
    
    private

    def animal_request
      RescueGroupsV5::Requests::Animal.new(@api_key)
    end
  end
end
