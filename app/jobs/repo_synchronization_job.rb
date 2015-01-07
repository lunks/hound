class RepoSynchronizationJob < ActiveJob::Base
  queue_as :high

  before_enqueue :set_refreshing_repos

  def perform(user_id, github_token)
    user = User.find(user_id)
    synchronization = RepoSynchronization.new(user, github_token)
    synchronization.start
    user.update_attribute(:refreshing_repos, false)
  rescue Resque::TermException
    retry_job
  end

  def set_refreshing_repos
    User.set_refreshing_repos(arguments.first)
  end
end
