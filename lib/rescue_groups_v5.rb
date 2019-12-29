# frozen_string_literal: true

require "rescue_groups_v5/version"
require "rescue_groups_v5/config"
require "rescue_groups_v5/requests/request"
require "rescue_groups_v5/requests/response"
require "rescue_groups_v5/requests/org"
require "rescue_groups_v5/requests/animal"
require "rescue_groups_v5/client"

module RescueGroupsV5
  class Error < StandardError; end
end
