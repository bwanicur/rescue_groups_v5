module RescueGroupsV5
  class Client
    def list_animals(opts = {})
      RescueGroupsV5::Requests::Animal.new.list(opts)
    end

    def search_animals
      # RescueGroupsV5::Requests::Animal.new.search()
    end

    def get_animal
      # RescueGroupsV5::Requests::Animal.new.find()
    end

    def search_organizations
    end

    def get_organization
    end
  end
end
