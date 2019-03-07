module RescueGroupsV5
  class Config
    private_class_method :new

    @@configuration = {}

    # TODO: RDOC here
    def self.set(key, value)
      @@configuration[key] = value
    end

    def self.read(key)
      key ? (@@configuration[key.to_s] || @configuration[key.to_sym]) : @@configuration
    end
  end
end
