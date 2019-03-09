module RescueGroupsV5
  class Client
    def initialize(api_key = nil)
      @api_key = api_key || Config.read(:api_key)
    end

    def list_animals(opts = {})
      animal_request.list(opts)
    end

    def search_animals
      animal_request.search(opts)
    end

    def get_animal
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
