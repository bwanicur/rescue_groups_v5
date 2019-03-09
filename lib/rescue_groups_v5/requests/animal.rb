module RescueGroupsV5
  module Requests
    class Animal
      PATH = '/animals'

      # TODO: YARD DOC HERE
      def list(opts = {})
        Request.new.get(PATH, opts)
      end

      # TODO: YARD DOC HERE
      def search(opts = {})
        Request.new.post("/#{PATH}/search", opts)
      end

      # TODO: YARD DOC HERE
      def find(id)
        Request.new.get("#{PATH}/#{id}", opts)
      end
    end
  end
end
