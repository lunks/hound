require 'octokit'

class LargeBuildJob < ActiveJob::Base
  include Buildable

  queue_as :low
end
