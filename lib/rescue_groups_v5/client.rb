module RescueGroupsV5
  class Client
    def initialize(api_key = nil)
      @api_key = api_key || Config.read(:api_key)
    end

    def search_animals
      animal_request.search(opts)
    end

    def get_animal(id, opts = {})
      animal_request.find(id, opts)
    end

    def search_orgs(opts = {})
    end

    def get_org(id, opts = {})
    end

    def get_org_animals(org_id, opts = {})
    end

    private

    def animal_request
      RescueGroupsV5::Requests::Animal.new(@api_key)
    end

    def org_request
      RescueGroupsV5::Requests::Org.new(@api_key)
    end
  end
end
