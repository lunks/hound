require "spec_helper"

describe RepoSynchronizationJob do
  describe "#set_refreshing_repos" do
    it "sets refreshing_repos to true" do
      user = create(:user)

      job = RepoSynchronizationJob.new(user.id, "token")
      job.set_refreshing_repos

      expect(user.reload).to be_refreshing_repos
    end

    it "returns true if not refreshing" do
      user = create(:user)

      job = RepoSynchronizationJob.new(user.id, "token")
      expect(job.set_refreshing_repos).
        to be true
    end

    it "returns false if already refreshing" do
      user = create(:user, refreshing_repos: true)

      job = RepoSynchronizationJob.new(user.id, "token")
      expect(job.set_refreshing_repos).
        to be false
    end
  end

  describe "#perform" do
    it "syncs repos and sets refreshing_repos to false" do
      user = create(:user, refreshing_repos: true)
      github_token = "token"
      synchronization = double(:repo_synchronization, start: nil)
      allow(RepoSynchronization).to receive(:new).and_return(synchronization)

      RepoSynchronizationJob.perform_now(user.id, github_token)

      expect(RepoSynchronization).to have_received(:new).with(
        user,
        github_token
      )
      expect(synchronization).to have_received(:start)
      expect(user.reload).not_to be_refreshing_repos
    end

    it "retries when Resque::TermException is raised" do
      allow(User).to receive(:find).and_raise(Resque::TermException.new(1))
      user_id = "userid"
      github_token = "token"

      job = RepoSynchronizationJob.new(user_id, github_token)
      allow(job).to receive(:retry_job)
      job.perform_now

      expect(job).to have_received(:retry_job)
    end
  end
end
