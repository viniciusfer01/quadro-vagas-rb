class HomeController < ApplicationController
  allow_unauthenticated_access
  def index
    @job_postings = JobPosting.all
  end

  def search
    if params[:query].present?
      @job_postings = JobPosting.search_jobs(params[:query])
      return render :index
    end
    redirect_to root_path, alert: t(".alert")
  end
end
