require "rescue_groups_v5/version"
require "rescue_groups_v5/config"
require "rescue_groups_v5/client"
Dir[File.join(__dir__, 'rescue_groups_v5/requests', '*.rb')].each { |file| require file }

module RescueGroupsV5
  class Error < StandardError; end
end
