class RepoInformationJob < ActiveJob::Base
  queue_as :low

  def perform(repo_id)
    repo = Repo.find(repo_id)
    repo.touch

    github = GithubApi.new
    github_data = github.repo(repo.full_github_name)

    repo.update_attributes!(
      private: github_data[:private],
      in_organization: github_data[:organization].present?
    )
  rescue Resque::TermException
    retry_job
  end
end
