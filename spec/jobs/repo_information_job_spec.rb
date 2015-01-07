require 'spec_helper'

describe RepoInformationJob do
  it 'collects repo privacy and organization from GitHub' do
    repo = create(:repo, private: false, in_organization: false)
    stub_repo_with_org_request(repo.full_github_name)

    RepoInformationJob.perform_now(repo.id)

    repo.reload
    expect(repo).to be_private
    expect(repo).to be_in_organization
  end

  it 'retries when Resque::TermException is raised' do
    repo = create(:repo)
    allow(Repo).to receive(:find).and_raise(Resque::TermException.new(1))

    job = RepoInformationJob.new(repo.id)
    allow(job).to receive(:retry_job)

    job.perform_now

    expect(job).to have_received(:retry_job)
  end
end
