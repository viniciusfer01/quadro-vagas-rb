class JobPostingsController < ApplicationController
  allow_unauthenticated_access
  before_action :set_job_posting, only: %i[ show ]
  before_action :check_inactive_job_posting, only: %i[ show ]

  def show; end

  private

  def set_job_posting
    @job_posting = JobPosting.unscoped.find(params[:id])
  end

  def check_inactive_job_posting
    redirect_to root_path if @job_posting.inactive?
  end
end
