require 'octokit'

class SmallBuildJob < ActiveJob::Base
  include Buildable

  queue_as :medium
end
