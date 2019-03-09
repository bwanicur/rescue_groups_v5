module RescueGroupsV5
  class Config
    private_class_method :new

    @@conf = {}

    if ENV['RESCUE_GROUPS_V5_API_KEY']
      @@conf[:api_key] = ENV['RESCUE_GROUPS_V5_API_KEY']
    end

    def self.set(key, value)
      @@conf[key] = value
    end

    def self.read(key)
      key ? (@@conf[key.to_s] || @@conf[key.to_sym]) : @@conf
    end
  end
end
