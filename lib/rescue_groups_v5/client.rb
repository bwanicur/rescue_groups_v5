require 'faraday'
require_relative './services/filter_builder'

module RescueGroupsV5
  class Client
    PUBLIC_URL = 'https://rescuegroups.org/v5/public'

    def initalize(atts = {})
      @api_key = atts[:api_key] || Config.read(:api_key)
    end

    def get_request(path, opts = {})
      # PUBLIC_URL + path
      # TODO
    end

    def post_request(path, opts = {})
      # PUBLIC_URL + path
      # TODO
    end

    def connection
      @connection ||= Faraday.new
    end

    private

    def headers
      {
        'Content-Type' => 'application/json',
        'Authorization' => @api_key,
      }.merge(connection.headers)
    end

    # TODO: each one of these methods might need to consume a service

    def includes_str(includes = [])
      # TODO: not sure - wait until V5 API is updated
    end

    def sort_str(opts = {})
      # TODO: not sure - wait until V5 API is updated
    end

    def fields_str(fields = [])
      # TODO: not sure - wait until V5 API is updated
    end

    def filters_data(opts = {})
      {
        filters: FilterBuilder.transform_filters(opts[:filters]) || [],
        filterRadius: {
          zipcode: opts[:zipcode],
          miles: opts[:radius_in_miles]
        }
      }
    end
  end
end
