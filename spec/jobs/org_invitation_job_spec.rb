require "spec_helper"

describe OrgInvitationJob do
  it "accepts invitations" do
    github = double("GithubApi", accept_pending_invitations: nil)
    allow(GithubApi).to receive(:new).and_return(github)

    OrgInvitationJob.perform_now

    expect(github).to have_received(:accept_pending_invitations)
  end

  it "retries when Resque::TermException is raised" do
    allow(GithubApi).to receive(:new).and_raise(Resque::TermException.new(1))

    job = OrgInvitationJob.new
    allow(job).to receive(:retry_job)
    job.perform_now

    expect(job).to have_received(:retry_job)
  end
end
