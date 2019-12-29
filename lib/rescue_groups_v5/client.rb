# frozen_string_literal: true

module RescueGroupsV5
  class Client
    def initialize(api_key, global_opts = {})
      @api_key = api_key
      @global_opts = global_opts
    end

    def search_animals(opts = {})
      process_response(animal_request.search(opts))
    end

    def get_animal(id, opts = {})
      process_response(animal_request.find(id, opts))
    end

    def get_animal_breeds(opts = {})
      process_response(animal_request.get_breeds(opts))
    end

    def search_orgs(opts = {})
      process_response(org_request.search(opts))
    end

    def get_org(id, opts = {})
      process_response(org_request.find(id, opts))
    end

    def get_org_animals(org_id, opts = {})
      process_response(org_request.list_animals(org_id, opts))
    end

    def search_org_animals(org_id, opts = {})
      process_response(org_request.search_animals(org_id, opts))
    end

    private

    def process_response(response)
      Response.new(response.body, @global_opts[:nest_data]).run
    end

    def animal_request
      @animal_request ||= Requests::Animal.new(@api_key)
    end

    def org_request
      @org_request ||= Requests::Org.new(@api_key)
    end
  end
end
