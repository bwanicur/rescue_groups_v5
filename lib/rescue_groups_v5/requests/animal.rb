module RescueGroupsV5
  module Requests
    class Animal
      PATH = '/animals'

      def list(opts = {})
        Request.new.get(PATH, opts)
      end

      def search(opts = {})
        Request.new.post("/#{PATH}/search", opts)
      end

      def find(id)
        Request.new.get("#{PATH}/#{id}", opts)
      end
    end
  end
end
