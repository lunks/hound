class ActivationsController < ApplicationController
  class FailedToActivate < StandardError; end
  class CannotActivatePaidRepo < StandardError; end

  respond_to :json

  before_action :check_repo_plan

  def create
    if activator.enable(repo, session[:github_token])
      JobQueue.push(OrgInvitationJob)
      analytics.track_enabled(repo)
      render json: repo, status: :created
    else
      report_exception(
        FailedToActivate.new('Failed to enable repo'),
        user_id: current_user.id,
        repo_id: params[:repo_id]
      )
      head 502
    end
  end

  private

  def repo
    @repo ||= current_user.repos.find(params[:repo_id])
  end

  def activator
    RepoActivator.new
  end

  def check_repo_plan
    if repo.plan_price > 0
      raise CannotActivatePaidRepo
    end
  end
end
