module RescueGroupsV5
  class Client
    def initialize(api_key = nil)
      @api_key = api_key || Config.read(:api_key)
    end

    def search_animals(opts = {})
      animal_request.search(opts)
    end

    def get_animal(id, opts = {})
      animal_request.find(id, opts)
    end

    def get_animal_breeds(opts = {})
      animal_request.get_breeds(opts)
    end

    def search_orgs(opts = {})
      org_request.search(opts)
    end

    def get_org(id, opts = {})
      org_request.find(id, opts)
    end

    def get_org_animals(org_id, opts = {})
      org_request.list_animals(org_id, opts)
    end

    def search_org_animals(org_id, opts = {})
      org_request.search_animals(org_id, opts)
    end

    private

    def animal_request
      Requests::Animal.new(@api_key)
    end

    def org_request
      Requests::Org.new(@api_key)
    end
  end
end
