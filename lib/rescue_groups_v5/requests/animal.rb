module RescueGroupsV5
  module Requests
    class Animal < Base
      PATH = '/animals'

      # TODO: YARD DOC HERE
      def search(opts = {})
        post_request("/#{PATH}/search", opts)
      end

      # TODO: YARD DOC HERE
      def find(id)
        get_request(PATH, opts)
      end
    end
  end
end
