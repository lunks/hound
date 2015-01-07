class OrgInvitationJob < ActiveJob::Base

  queue_as :high

  def perform
    github = GithubApi.new
    github.accept_pending_invitations
  rescue Resque::TermException
    retry_job
  end
end
