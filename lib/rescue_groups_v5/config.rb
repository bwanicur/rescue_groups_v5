module RescueGroupsV5
  class Config
    private_class_method :new

    @@configuration = {}

    # TODO: RDOC here
    def self.set(atts = {})
      @@configuration.merge!(atts)
    end

    def self.read(key)
      key ? @@configuration[key] : @@configuration
    end
  end
end
